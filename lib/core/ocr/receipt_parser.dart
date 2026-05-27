/// 解析 Mandarin Windsor 收据 OCR 文本
class ParsedReceipt {
  const ParsedReceipt({
    this.orderNumber,
    this.date,
    this.paymentType,
    this.orderValue,
    this.tip,
    this.address,
  });

  final String? orderNumber;
  final String? date;          // 'YYYY-MM-DD'
  final String? paymentType;   // 'online' | 'card' | 'cash'
  final double? orderValue;    // Amount
  final double? tip;           // 仅 online 的 'TIPS *Paid $X'
  final String? address;       // 'Address, City, Postal' 拼接
}

ParsedReceipt parseReceipt(String text) {
  final lines = text
      .split(RegExp(r'\r?\n'))
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  return ParsedReceipt(
    orderNumber: _extractOrderNumber(lines),
    date: _extractDate(lines),
    paymentType: _extractPaymentType(lines),
    orderValue: _extractAmount(lines),
    tip: _extractTip(lines),
    address: _extractAddress(lines),
  );
}

String? _extractOrderNumber(List<String> lines) {
  // 模糊匹配：'Order Number: 16' / 'Order Mnber: 32' / 'Order Nunber: ...'
  // 仅匹配以 Order 开头、单词后冒号、值为 1-5 位纯数字、行尾。
  // 避免误匹配 'Order Time:2025-...' / 'Online Order#:WI-...'
  final re = RegExp(r'^Order\s+\S+\s*[:：]\s*(\d{1,5})\s*$',
      caseSensitive: false);
  for (final line in lines) {
    final m = re.firstMatch(line);
    if (m != null) return m.group(1);
  }
  return null;
}

String? _extractDate(List<String> lines) {
  // 优先：'Order Time:YYYY-MM-DD ...'
  final strict = RegExp(
      r'Order\s*Time\s*[:：]\s*(\d{4})[-/](\d{1,2})[-/](\d{1,2})',
      caseSensitive: false);
  // 兜底：任意行的 YYYY-MM-DD 模式（年份以 20 开头）
  final loose = RegExp(r'(20\d{2})[-/](\d{1,2})[-/](\d{1,2})');
  for (final line in lines) {
    final m = strict.firstMatch(line);
    if (m != null) {
      return '${m.group(1)}-${m.group(2)!.padLeft(2, '0')}-${m.group(3)!.padLeft(2, '0')}';
    }
  }
  for (final line in lines) {
    final m = loose.firstMatch(line);
    if (m != null) {
      return '${m.group(1)}-${m.group(2)!.padLeft(2, '0')}-${m.group(3)!.padLeft(2, '0')}';
    }
  }
  return null;
}

String? _extractPaymentType(List<String> lines) {
  // 整段文本搜索关键词；优先匹配最明确的
  final joined = lines.join('\n');
  if (RegExp(r'Card\s*for\s*Delivery', caseSensitive: false).hasMatch(joined)) {
    return 'card';
  }
  // Online 关键词：尾部 'Online' 单独成行，或顶部 'WebDelivery'
  if (RegExp(r'^\s*Online\s*$', caseSensitive: false, multiLine: true)
          .hasMatch(joined) ||
      RegExp(r'WebDelivery', caseSensitive: false).hasMatch(joined)) {
    return 'online';
  }
  if (RegExp(r'^\s*Cash\s*$', caseSensitive: false, multiLine: true)
      .hasMatch(joined)) {
    return 'cash';
  }
  return null;
}

double? _extractAmount(List<String> lines) {
  // 优先：'Amount: $35.00' 同行匹配
  final inline = RegExp(r'A\w*ount\s*[:：]\s*[\$Ss]?\s*([0-9]+\.[0-9]{2})',
      caseSensitive: false);
  for (final line in lines) {
    final m = inline.firstMatch(line);
    if (m != null) {
      final v = double.tryParse(m.group(1)!);
      if (v != null) return v;
    }
  }
  // 兜底：$ 可能被识别成 S/s；取所有金额中的最大值（收据 Amount 总是最大）
  // 排除明显是百分比/编号的：限定 [\$Ss]\s* 前缀
  final money = RegExp(r'[\$Ss]\s*([0-9]+\.[0-9]{2})');
  double? best;
  for (final line in lines) {
    for (final m in money.allMatches(line)) {
      final v = double.tryParse(m.group(1)!);
      if (v == null) continue;
      if (best == null || v > best) best = v;
    }
  }
  return best;
}

double? _extractTip(List<String> lines) {
  // 'TIPS *Paid $6.23 tips' 或同行/相邻行的变体；只在 TIPS 关键词附近抓
  final re = RegExp(r'\*?\s*Paid\s*\$?\s*([0-9]+\.[0-9]{2})\s*tips?',
      caseSensitive: false);
  for (final line in lines) {
    final m = re.firstMatch(line);
    if (m != null) {
      final v = double.tryParse(m.group(1)!);
      if (v != null && v > 0) return v;
    }
  }
  return null;
}

String? _extractAddress(List<String> lines) {
  // 模糊匹配字段名（兼容 Atress/Adress/Postal/Rostal 等 OCR 错字）
  final addrRe = RegExp(r'^A\w{2,8}ess?\s*[:：]\s*(.+)$', caseSensitive: false);
  final unitRe = RegExp(r'^Unit\s*[:：]\s*(.+)$', caseSensitive: false);
  final cityRe = RegExp(r'^City\s*[:：]\s*(.+)$', caseSensitive: false);
  final postalRe = RegExp(r'^[PR]\w{2,6}al\s*[:：]\s*(.+)$', caseSensitive: false);

  // 收集所有匹配 Address-like 的行索引
  final addrIdxs = <int>[];
  for (var i = 0; i < lines.length; i++) {
    if (addrRe.hasMatch(lines[i])) addrIdxs.add(i);
  }
  if (addrIdxs.isEmpty) return null;

  // 顾客地址：若有多个 Address: 行，跳过第一个（餐厅地址）；否则就用唯一一个
  final customerAddrIdx = addrIdxs.length > 1 ? addrIdxs[1] : addrIdxs[0];
  var addr = addrRe.firstMatch(lines[customerAddrIdx])!.group(1)!.trim();
  addr = addr.replaceAll(RegExp(r'[,，]\s*$'), '').trim();

  // 在 Address 之后的有限范围内（最多 6 行）收集 Unit/City/Postal
  String? unit, city, postal;
  final endIdx = (customerAddrIdx + 7).clamp(0, lines.length);
  for (var i = customerAddrIdx + 1; i < endIdx; i++) {
    final line = lines[i];
    unit ??= unitRe.firstMatch(line)?.group(1)?.trim();
    city ??= cityRe.firstMatch(line)?.group(1)?.trim();
    postal ??= postalRe.firstMatch(line)?.group(1)?.trim();
  }

  final parts = <String>[addr];
  if (unit != null && unit.isNotEmpty) parts.add('Unit $unit');
  if (city != null && city.isNotEmpty) parts.add(city);
  if (postal != null && postal.isNotEmpty) parts.add(postal);
  return parts.join(', ');
}
