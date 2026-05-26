import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/calc/order_calc.dart';
import 'package:trip_wage_app/core/db/database.dart';

Order _o({
  String date = '2026-05-25',
  String paymentType = 'online',
  double orderValue = 0,
  double paymentAmount = 0,
  double changeReturned = 0,
  double extraCashTip = 0,
  double distanceKm = 0,
}) {
  final now = DateTime.now();
  return Order(
    id: 0,
    date: date,
    orderNumber: '',
    paymentType: paymentType,
    orderValue: orderValue,
    paymentAmount: paymentAmount,
    changeReturned: changeReturned,
    extraCashTip: extraCashTip,
    distanceKm: distanceKm,
    address: '',
    notes: '',
    createdAt: now,
    updatedAt: now,
  );
}

const _params = WageParams(
  baseHourlyRate: 8.5,
  fuelPerOrder: 3.5,
  longTripThresholdKm: 10,
  longTripExtraFuel: 3.5,
);

void main() {
  group('calcOrder', () {
    test('online: tip + fuel, short trip', () {
      final c = calcOrder(
        _o(paymentType: 'online', orderValue: 20, paymentAmount: 23, distanceKm: 5),
        _params,
      );
      expect(c.tipsTotal, 3);
      expect(c.fuelFee, 3.5);
      expect(c.totalIncome, 6.5);
      expect(c.isLongTrip, false);
    });

    test('long trip gets extra fuel', () {
      final c = calcOrder(
        _o(orderValue: 10, paymentAmount: 10, distanceKm: 12),
        _params,
      );
      expect(c.isLongTrip, true);
      expect(c.fuelFee, 7.0);
    });

    test('cash: tips = paid - value - change + extra', () {
      final c = calcOrder(
        _o(
          paymentType: 'cash',
          orderValue: 20,
          paymentAmount: 25,
          changeReturned: 2,
          extraCashTip: 1,
        ),
        _params,
      );
      expect(c.tipsTotal, 4); // 25 - 20 - 2 + 1
    });

    test('tips clamped to 0', () {
      final c = calcOrder(
        _o(orderValue: 30, paymentAmount: 20),
        _params,
      );
      expect(c.tipsTotal, 0);
    });
  });

  group('calcDailySummary', () {
    test('mixed day', () {
      final orders = [
        _o(
          paymentType: 'online',
          orderValue: 20,
          paymentAmount: 23,
          distanceKm: 5,
        ),
        _o(
          paymentType: 'cash',
          orderValue: 15,
          paymentAmount: 20,
          changeReturned: 3,
          distanceKm: 12,
        ),
      ];
      final s = calcDailySummary(
        orders: orders,
        workHours: 8,
        params: _params,
      );

      expect(s.actualTrips, 2);
      expect(s.effectiveTrips, 3); // 1 + 2 (long)
      expect(s.longTrips, 1);
      expect(s.totalDistance, (5 + 12) * 2);
      expect(s.totalTips, 3 + 2); // online tip 3 + cash tip 2
      expect(s.fuelFeeTotal, 3.5 + 7.0);
      expect(s.basePayment, 8 * 8.5);
      expect(s.totalWage, 68 + 10.5 + 5);
      expect(s.cashOrderValue, 15);
      expect(s.nonCashTips, 3); // online: 23 - 20
      expect(s.restaurantSettlement, 12); // 15 - 3
    });

    test('zero work hours → hourlyWage = 0', () {
      final s = calcDailySummary(orders: [], workHours: 0, params: _params);
      expect(s.hourlyWage, 0);
    });
  });

  group('calcWorkHours', () {
    test('basic', () {
      expect(calcWorkHours('08:00', '17:00'), 9);
      expect(calcWorkHours('08:30', '17:00'), 8.5);
    });
    test('crosses midnight', () {
      expect(calcWorkHours('22:00', '02:00'), 4);
    });
    test('empty returns 0', () {
      expect(calcWorkHours('', '17:00'), 0);
      expect(calcWorkHours('08:00', ''), 0);
    });
  });
}
