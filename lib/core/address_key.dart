/// 把订单地址归一化成"同一地点"的分组 key。
///
/// 期望的地址格式（手动维护，OCR 结果只是起点，会被改写覆盖）：
///     `1525 Dufferin Pl, Windsor, ON N8X 3K6`
///
/// 匹配规则（按优先级）：
/// 1. 加拿大邮编（A1A 1A1，允许中间无空格、大小写）→ `zip:N8X3K6`
/// 2. 美国邮编（末尾的 12345 或 12345-6789）→ `zip:10001`
/// 3. 新加坡邮编（末尾 6 位数字）→ `zip:123456`
/// 4. 都没有：小写 + trim + 折叠多余空白 → `addr:123 main st`
///
/// 空字符串返回空 key，调用方自行决定是否过滤。
String addressGroupKey(String raw) {
  final addr = raw.trim();
  if (addr.isEmpty) return '';

  final ca = RegExp(
    r'\b[A-Z]\d[A-Z]\s*\d[A-Z]\d\b',
    caseSensitive: false,
  ).firstMatch(addr);
  if (ca != null) {
    final normalized =
        ca.group(0)!.toUpperCase().replaceAll(RegExp(r'\s+'), '');
    return 'zip:$normalized';
  }

  final us = RegExp(r'\b(\d{5}(?:-\d{4})?)\s*$').firstMatch(addr);
  if (us != null) {
    return 'zip:${us.group(1)!}';
  }

  final sg = RegExp(r'\b(\d{6})\s*$').firstMatch(addr);
  if (sg != null) {
    return 'zip:${sg.group(1)!}';
  }

  final collapsed = addr.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  return 'addr:$collapsed';
}
