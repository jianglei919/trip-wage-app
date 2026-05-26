import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/backup_import.dart';
import 'package:trip_wage_app/core/db/database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() async => db.close());

  test('imports orders and workTimes from JSON', () async {
    const json = '''
    {
      "schemaVersion": 1,
      "orders": [
        {
          "date": "2026-05-24",
          "orderNumber": "A001",
          "paymentType": "online",
          "orderValue": 20.5,
          "paymentAmount": 23,
          "changeReturned": 0,
          "extraCashTip": 0,
          "distanceKm": 5,
          "notes": "test"
        },
        {
          "date": "2026-05-25",
          "paymentType": "cash",
          "orderValue": 15,
          "paymentAmount": 20,
          "changeReturned": 3,
          "distanceKm": 12
        }
      ],
      "workTimes": [
        { "date": "2026-05-24", "startTime": "09:00", "endTime": "18:00", "workHours": 9 }
      ]
    }
    ''';

    final result = await importBackupFromJson(db, json);
    expect(result.orders, 2);
    expect(result.workTimes, 1);

    final orders = await db.select(db.orders).get();
    expect(orders, hasLength(2));
    expect(orders.first.orderValue, 20.5);
    expect(orders.last.paymentType, 'cash');

    final wt = await db.select(db.workTimes).getSingle();
    expect(wt.date, '2026-05-24');
    expect(wt.workHours, 9);
  });

  test('workTime upsert on conflict', () async {
    await importBackupFromJson(db, '''
    {"orders": [], "workTimes":[
      {"date":"2026-05-24","startTime":"08:00","endTime":"17:00","workHours":9}
    ]}''');
    await importBackupFromJson(db, '''
    {"orders": [], "workTimes":[
      {"date":"2026-05-24","startTime":"10:00","endTime":"19:00","workHours":9}
    ]}''');

    final all = await db.select(db.workTimes).get();
    expect(all, hasLength(1));
    expect(all.single.startTime, '10:00');
  });
}
