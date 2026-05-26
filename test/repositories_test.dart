import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/db/database.dart';
import 'package:trip_wage_app/repositories/order_repository.dart';
import 'package:trip_wage_app/repositories/settings_repository.dart';
import 'package:trip_wage_app/repositories/worktime_repository.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late WorkTimeRepository workTimes;
  late SettingsRepository settings;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    orders = OrderRepository(db);
    workTimes = WorkTimeRepository(db);
    settings = SettingsRepository(db);
  });

  tearDown(() async => db.close());

  group('OrderRepository', () {
    test('insert + getByDate', () async {
      await orders.insert(OrdersCompanion.insert(
        date: '2026-05-25',
        orderValue: const Value(20.5),
        extraCashTip: const Value(2),
        distanceKm: const Value(5),
      ));
      await orders.insert(OrdersCompanion.insert(
        date: '2026-05-25',
        orderValue: const Value(30),
      ));
      await orders.insert(OrdersCompanion.insert(
        date: '2026-05-24',
        orderValue: const Value(99),
      ));

      final today = await orders.getByDate('2026-05-25');
      expect(today, hasLength(2));
    });

    test('getByDateRange', () async {
      await orders.insert(
          OrdersCompanion.insert(date: '2026-05-20', orderValue: const Value(1)));
      await orders.insert(
          OrdersCompanion.insert(date: '2026-05-25', orderValue: const Value(2)));
      await orders.insert(
          OrdersCompanion.insert(date: '2026-06-01', orderValue: const Value(3)));

      final range = await orders.getByDateRange('2026-05-19', '2026-05-26');
      expect(range, hasLength(2));
    });

    test('dailyStats aggregates correctly', () async {
      await orders.insert(OrdersCompanion.insert(
        date: '2026-05-25',
        orderValue: const Value(20),
        extraCashTip: const Value(2),
        distanceKm: const Value(5),
      ));
      await orders.insert(OrdersCompanion.insert(
        date: '2026-05-25',
        orderValue: const Value(15),
        extraCashTip: const Value(1.5),
        distanceKm: const Value(8),
      ));

      final stats = await orders.getDailyStats('2026-05-25');
      expect(stats.orderCount, 2);
      expect(stats.totalOrderValue, 35);
      expect(stats.totalCashTip, 3.5);
      expect(stats.totalDistanceKm, 13);
    });

    test('update + delete', () async {
      final id = await orders.insert(OrdersCompanion.insert(
        date: '2026-05-25',
        orderValue: const Value(10),
      ));
      final row = (await orders.getByDate('2026-05-25')).first;
      expect(row.id, id);

      await orders.update(row.copyWith(orderValue: 99));
      final after = (await orders.getByDate('2026-05-25')).first;
      expect(after.orderValue, 99);

      await orders.delete(id);
      expect(await orders.getByDate('2026-05-25'), isEmpty);
    });
  });

  group('WorkTimeRepository', () {
    test('upsert is idempotent per date', () async {
      await workTimes.upsert(
          date: '2026-05-25',
          startTime: '08:00',
          endTime: '17:00',
          workHours: 9);
      await workTimes.upsert(
          date: '2026-05-25',
          startTime: '09:00',
          endTime: '18:00',
          workHours: 9);

      final row = await workTimes.getByDate('2026-05-25');
      expect(row, isNotNull);
      expect(row!.startTime, '09:00');
      expect(row.endTime, '18:00');
    });
  });

  group('SettingsRepository', () {
    test('default row exists with wageConfig defaults', () async {
      final s = await settings.get();
      expect(s.id, 1);
      expect(s.baseHourlyRate, 8.5);
      expect(s.fuelPerOrder, 3.5);
      expect(s.longTripThresholdKm, 10);
      expect(s.longTripExtraFuel, 3.5);
      expect(s.biweeklySettlementDays, 14);
      expect(s.biweeklyAnchorDate, '2026-04-20');
      expect(s.locale, 'zh');
    });

    test('partial update only changes provided fields', () async {
      await settings.update(baseHourlyRate: 10.0, locale: 'en');
      final s = await settings.get();
      expect(s.baseHourlyRate, 10.0);
      expect(s.locale, 'en');
      expect(s.fuelPerOrder, 3.5); // unchanged
    });

    test('resetToDefaults restores defaults', () async {
      await settings.update(baseHourlyRate: 99);
      await settings.resetToDefaults();
      final s = await settings.get();
      expect(s.baseHourlyRate, 8.5);
    });
  });
}
