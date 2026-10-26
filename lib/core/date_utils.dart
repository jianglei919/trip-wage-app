/// 本地日期工具（避免 UTC 偏移）
///
/// 日期在本应用里是"纯日期"（yyyy-MM-dd），没有时刻概念。
/// 因此所有加减/天数差都在 UTC 上算：UTC 没有夏令时，`Duration(days: 1)`
/// 恒等于一个日历天。若用本地时间算，夏令时切换日（如 2026-11-01 回拨，
/// 当天有 25 小时）会出现"本地午夜 + 24 小时仍是同一天"，从而让按天推进的
/// 循环永远停不下来。
String todayString() => formatLocal(DateTime.now());

String formatLocal(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

DateTime parseLocal(String s) {
  final p = _parts(s);
  return DateTime(p[0], p[1], p[2]);
}

List<int> _parts(String s) => s.split('-').map(int.parse).toList();

/// 纯日期运算用的 UTC 午夜（不受夏令时影响）
DateTime _utcOf(String s) {
  final p = _parts(s);
  return DateTime.utc(p[0], p[1], p[2]);
}

String addDays(String s, int days) =>
    formatLocal(_utcOf(s).add(Duration(days: days)));

/// b - a 的日历天数（b 在 a 之前为负）
int daysBetween(String a, String b) =>
    _utcOf(b).difference(_utcOf(a)).inDays;

/// [start, end] 闭区间内的每一天；start > end 时为空
List<String> dateSeq(String start, String end) {
  final n = daysBetween(start, end);
  if (n < 0) return const [];
  return [for (var i = 0; i <= n; i++) addDays(start, i)];
}

/// 包含某一天的双周周期 [start, end]
({String start, String end}) biweeklyCycleOf({
  required String date,
  required String anchorDate,
  required int cycleDays,
}) {
  final diff = daysBetween(anchorDate, date);
  final idx = diff >= 0
      ? diff ~/ cycleDays
      : ((diff - cycleDays + 1) ~/ cycleDays);
  final start = addDays(anchorDate, idx * cycleDays);
  return (start: start, end: addDays(start, cycleDays - 1));
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
  final diff = daysBetween(current.start, start);
  if (diff % cycleDays != 0) return null;
  if (daysBetween(start, end) != cycleDays - 1) return null;
  return diff ~/ cycleDays;
}
