import '../db/database.dart';

/// 单个订单的衍生数值
class OrderCalc {
  const OrderCalc({
    required this.tipsTotal,
    required this.fuelFee,
    required this.totalIncome,
    required this.isLongTrip,
  });

  final double tipsTotal;
  final double fuelFee;
  final double totalIncome;
  final bool isLongTrip;
}

/// 一天的汇总
class DailySummary {
  const DailySummary({
    required this.actualTrips,
    required this.effectiveTrips,
    required this.totalDistance,
    required this.basePayment,
    required this.fuelFeeTotal,
    required this.totalTips,
    required this.totalWage,
    required this.hourlyWage,
    required this.cashOrderValue,
    required this.nonCashTips,
    required this.restaurantSettlement,
  });

  final int actualTrips;
  final int effectiveTrips;
  final double totalDistance;
  final double basePayment;
  final double fuelFeeTotal;
  final double totalTips;
  final double totalWage;
  final double hourlyWage;
  final double cashOrderValue;
  final double nonCashTips;

  /// 正数：你欠餐馆；负数：餐馆欠你
  final double restaurantSettlement;

  int get longTrips => effectiveTrips - actualTrips;
}

class WageParams {
  const WageParams({
    required this.baseHourlyRate,
    required this.fuelPerOrder,
    required this.longTripThresholdKm,
    required this.longTripExtraFuel,
  });

  factory WageParams.fromSettings(AppSetting s) => WageParams(
        baseHourlyRate: s.baseHourlyRate,
        fuelPerOrder: s.fuelPerOrder,
        longTripThresholdKm: s.longTripThresholdKm,
        longTripExtraFuel: s.longTripExtraFuel,
      );

  final double baseHourlyRate;
  final double fuelPerOrder;
  final double longTripThresholdKm;
  final double longTripExtraFuel;
}

OrderCalc calcOrder(Order order, WageParams p) {
  final tips = order.paymentAmount -
      order.orderValue -
      order.changeReturned +
      order.extraCashTip;
  final tipsTotal = tips < 0 ? 0.0 : tips;

  final isLong = order.distanceKm >= p.longTripThresholdKm;
  final fuelFee = p.fuelPerOrder + (isLong ? p.longTripExtraFuel : 0.0);

  return OrderCalc(
    tipsTotal: tipsTotal,
    fuelFee: fuelFee,
    totalIncome: fuelFee + tipsTotal,
    isLongTrip: isLong,
  );
}

DailySummary calcDailySummary({
  required List<Order> orders,
  required double workHours,
  required WageParams params,
}) {
  double totalDistance = 0;
  double totalTips = 0;
  double fuelFeeTotal = 0;
  int effectiveTrips = 0;
  double cashOrderValue = 0;
  double nonCashTips = 0;

  for (final o in orders) {
    final c = calcOrder(o, params);
    totalDistance += o.distanceKm * 2; // 往返
    totalTips += c.tipsTotal;
    fuelFeeTotal += c.fuelFee;
    effectiveTrips += c.isLongTrip ? 2 : 1;

    if (o.paymentType == 'cash') {
      cashOrderValue += o.orderValue;
    } else if (o.paymentType == 'online' || o.paymentType == 'card') {
      final fromRestaurant = o.paymentAmount - o.orderValue;
      if (fromRestaurant > 0) nonCashTips += fromRestaurant;
    }
  }

  final basePayment = workHours * params.baseHourlyRate;
  final totalWage = basePayment + fuelFeeTotal + totalTips;
  final hourlyWage = workHours > 0 ? totalWage / workHours : 0.0;

  return DailySummary(
    actualTrips: orders.length,
    effectiveTrips: effectiveTrips,
    totalDistance: totalDistance,
    basePayment: basePayment,
    fuelFeeTotal: fuelFeeTotal,
    totalTips: totalTips,
    totalWage: totalWage,
    hourlyWage: hourlyWage,
    cashOrderValue: cashOrderValue,
    nonCashTips: nonCashTips,
    restaurantSettlement: cashOrderValue - nonCashTips,
  );
}

/// "HH:mm" - "HH:mm" → 小时数（跨午夜自动 +24h）
double calcWorkHours(String start, String end) {
  if (start.isEmpty || end.isEmpty) return 0;
  final s = start.split(':');
  final e = end.split(':');
  if (s.length != 2 || e.length != 2) return 0;
  final sh = int.tryParse(s[0]) ?? 0;
  final sm = int.tryParse(s[1]) ?? 0;
  final eh = int.tryParse(e[0]) ?? 0;
  final em = int.tryParse(e[1]) ?? 0;
  var h = eh - sh;
  final m = em - sm;
  if (h < 0) h += 24;
  return h + m / 60.0;
}
