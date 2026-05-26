/// 本地日期工具（避免 UTC 偏移）
String todayString() => formatLocal(DateTime.now());

String formatLocal(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

DateTime parseLocal(String s) {
  final parts = s.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

String addDays(String s, int days) =>
    formatLocal(parseLocal(s).add(Duration(days: days)));

/// 包含某一天的双周周期 [start, end]
({String start, String end}) biweeklyCycleOf({
  required String date,
  required String anchorDate,
  required int cycleDays,
}) {
  final anchor = parseLocal(anchorDate);
  final d = parseLocal(date);
  final diff = d.difference(anchor).inDays;
  final idx = diff >= 0
      ? diff ~/ cycleDays
      : ((diff - cycleDays + 1) ~/ cycleDays);
  final start = anchor.add(Duration(days: idx * cycleDays));
  final end = start.add(Duration(days: cycleDays - 1));
  return (start: formatLocal(start), end: formatLocal(end));
}

/// 返回某周期相对当前周期的偏移（-1/0/1...）
/// 若选中范围不与周期对齐（起始不在锚点序列上 或 结束 != start + cycleDays-1），返回 null
int? biweeklyCycleOffset({
  required String start,
  required String end,
  required String anchorDate,
  required int cycleDays,
}) {
  final current = biweeklyCycleOf(
      date: todayString(),
      anchorDate: anchorDate,
      cycleDays: cycleDays);
  final s = parseLocal(start);
  final e = parseLocal(end);
  final curStart = parseLocal(current.start);
  final diff = s.difference(curStart).inDays;
  if (diff % cycleDays != 0) return null;
  if (e.difference(s).inDays != cycleDays - 1) return null;
  return diff ~/ cycleDays;
}
