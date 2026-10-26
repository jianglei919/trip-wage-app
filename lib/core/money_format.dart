/// 金额显示：负数为 -$x.xx；四舍五入到分后为 0 的负数显示为 $0.00，避免出现 -$0.00
String formatMoney(double v) {
  final s = v.abs().toStringAsFixed(2);
  return v < 0 && s != '0.00' ? '-\$$s' : '\$$s';
}
