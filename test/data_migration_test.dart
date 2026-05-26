import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/data_migration.dart';
import 'package:trip_wage_app/core/db/database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('copies notes -> address only when address is empty', () async {
    // 三种情况
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-05-01',
          notes: const Value('123 Main St'),
        )); // 地址空、notes 非空 → 应迁移
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-05-02',
          address: const Value('Existing'),
          notes: const Value('whatever'),
        )); // 地址已有 → 不动
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-05-03',
        )); // 地址空、notes 也空 → 不动

    final count = await copyNotesToEmptyAddress(db);
    expect(count, 1);

    final rows = await db.select(db.orders).get();
    final a = rows.firstWhere((r) => r.date == '2026-05-01');
    final b = rows.firstWhere((r) => r.date == '2026-05-02');
    final c = rows.firstWhere((r) => r.date == '2026-05-03');

    expect(a.address, '123 Main St');
    expect(a.notes, '123 Main St'); // notes 保留
    expect(b.address, 'Existing'); // 未被覆盖
    expect(c.address, ''); // 没动
  });

  test('idempotent: second run updates 0', () async {
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-05-01',
          notes: const Value('foo'),
        ));
    expect(await copyNotesToEmptyAddress(db), 1);
    expect(await copyNotesToEmptyAddress(db), 0);
  });
}
