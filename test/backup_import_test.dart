import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_wage_app/core/backup_export.dart';
import 'package:trip_wage_app/core/backup_import.dart';
import 'package:trip_wage_app/core/db/database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() async => db.close());

  test('xlsx backup round-trips orders + workTimes', () async {
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-05-24',
          orderNumber: const Value('A001'),
          paymentType: const Value('online'),
          orderValue: const Value(20.5),
          paymentAmount: const Value(23),
          extraCashTip: const Value(0),
          distanceKm: const Value(5),
          notes: const Value('test'),
        ));
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-05-25',
          paymentType: const Value('cash'),
          orderValue: const Value(15),
          paymentAmount: const Value(20),
          changeReturned: const Value(3),
          distanceKm: const Value(12),
        ));
    await db.into(db.workTimes).insert(WorkTimesCompanion.insert(
          date: '2026-05-24',
          startTime: const Value('09:00'),
          endTime: const Value('18:00'),
          workHours: const Value(9),
        ));

    final built = await buildBackupBytes(db);
    expect(built.result.orders, 2);
    expect(built.result.workTimes, 1);

    // 导入到一个全新的 DB
    final db2 = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db2.close);

    final result = await importBackupFromBytes(db2, built.bytes);
    expect(result.orders, 2);
    expect(result.workTimes, 1);

    final orders =
        await (db2.select(db2.orders)..orderBy([(t) => OrderingTerm.asc(t.date)]))
            .get();
    expect(orders, hasLength(2));
    expect(orders.first.orderValue, 20.5);
    expect(orders.first.orderNumber, 'A001');
    expect(orders.last.paymentType, 'cash');
    expect(orders.last.changeReturned, 3);

    final wt = await db2.select(db2.workTimes).getSingle();
    expect(wt.date, '2026-05-24');
    expect(wt.startTime, '09:00');
    expect(wt.workHours, 9);
  });

  test('re-import replaces previous data (only second backup remains)',
      () async {
    final excel = Excel.createExcel();
    if (excel.sheets.containsKey('Sheet1')) excel.delete('Sheet1');
    excel[kOrdersSheet].appendRow(
      kOrdersSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
    );
    excel[kWorkTimesSheet].appendRow(
      kWorkTimesSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
    );
    excel[kWorkTimesSheet].appendRow(<CellValue?>[
      TextCellValue('2026-05-24'),
      TextCellValue('08:00'),
      TextCellValue('17:00'),
      DoubleCellValue(9),
    ]);
    final bytes1 = excel.encode()!;
    await importBackupFromBytes(db, bytes1);

    final excel2 = Excel.createExcel();
    if (excel2.sheets.containsKey('Sheet1')) excel2.delete('Sheet1');
    excel2[kOrdersSheet].appendRow(
      kOrdersSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
    );
    excel2[kWorkTimesSheet].appendRow(
      kWorkTimesSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
    );
    excel2[kWorkTimesSheet].appendRow(<CellValue?>[
      TextCellValue('2026-05-24'),
      TextCellValue('10:00'),
      TextCellValue('19:00'),
      DoubleCellValue(9),
    ]);
    final bytes2 = excel2.encode()!;
    await importBackupFromBytes(db, bytes2);

    final all = await db.select(db.workTimes).get();
    expect(all, hasLength(1));
    expect(all.single.startTime, '10:00');
  });

  test('rejects file without expected sheets', () async {
    final excel = Excel.createExcel();
    final bytes = excel.encode()!;
    expect(
      () => importBackupFromBytes(db, bytes),
      throwsA(isA<FormatException>()),
    );
  });

  test('import wipes pre-existing data not in the backup', () async {
    // 库里先有一条用户当前的订单
    await db.into(db.orders).insert(OrdersCompanion.insert(
          date: '2026-01-01',
          orderNumber: const Value('PRE-EXIST'),
        ));
    await db.into(db.workTimes).insert(WorkTimesCompanion.insert(
          date: '2026-01-01',
          startTime: const Value('05:00'),
          endTime: const Value('14:00'),
          workHours: const Value(9),
        ));

    // 备份里只包含完全不同日期的数据
    final excel = Excel.createExcel();
    if (excel.sheets.containsKey('Sheet1')) excel.delete('Sheet1');
    excel[kOrdersSheet].appendRow(
      kOrdersSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
    );
    excel[kOrdersSheet].appendRow(<CellValue?>[
      TextCellValue('2026-06-01'),
      TextCellValue('B-001'),
      TextCellValue('online'),
      DoubleCellValue(10),
      DoubleCellValue(12),
      DoubleCellValue(0),
      DoubleCellValue(0),
      DoubleCellValue(3),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
    ]);
    excel[kWorkTimesSheet].appendRow(
      kWorkTimesSheetColumns.map<CellValue?>(TextCellValue.new).toList(),
    );
    final bytes = excel.encode()!;

    final result = await importBackupFromBytes(db, bytes);
    expect(result.orders, 1);
    expect(result.workTimes, 0);

    // 旧的 2026-01-01 数据应被全部清空
    final orders = await db.select(db.orders).get();
    expect(orders, hasLength(1));
    expect(orders.single.orderNumber, 'B-001');

    final workTimes = await db.select(db.workTimes).get();
    expect(workTimes, isEmpty);
  });
}
