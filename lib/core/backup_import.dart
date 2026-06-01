import 'dart:io';

import 'package:drift/drift.dart';
import 'package:excel/excel.dart';

import 'backup_export.dart';
import 'db/database.dart';

class ImportResult {
  const ImportResult({required this.orders, required this.workTimes});
  final int orders;
  final int workTimes;
}

/// 从备份文件（.shbak / .xlsx，内部都是 xlsx 容器）导入到本地 SQLite。
///
/// **覆盖式**：导入前会先删除所有现有 orders 和 workTimes，
/// 再从备份文件载入。调用方应在导入前向用户确认。
Future<ImportResult> importBackupFromFile(AppDatabase db, File file) async {
  final bytes = await file.readAsBytes();
  return importBackupFromBytes(db, bytes);
}

Future<ImportResult> importBackupFromBytes(
  AppDatabase db,
  List<int> bytes,
) async {
  final excel = Excel.decodeBytes(bytes);

  final ordersSheet = excel.sheets[kOrdersSheet];
  final workTimesSheet = excel.sheets[kWorkTimesSheet];
  if (ordersSheet == null && workTimesSheet == null) {
    throw const FormatException(
      'Backup file is missing Orders / WorkTimes sheets',
    );
  }

  final orderRows = _readRowsByHeader(ordersSheet);
  final workTimeRows = _readRowsByHeader(workTimesSheet);

  await db.transaction(() async {
    await db.delete(db.orders).go();
    await db.delete(db.workTimes).go();
    await db.batch((b) {
      for (final r in orderRows) {
        final date = _str(r['date']);
        if (date.isEmpty) continue;
        b.insert(
          db.orders,
          OrdersCompanion.insert(
            date: date,
            orderNumber: Value(_str(r['orderNumber'])),
            paymentType: Value(_strOr(r['paymentType'], 'online')),
            orderValue: Value(_num(r['orderValue'])),
            paymentAmount: Value(_num(r['paymentAmount'])),
            changeReturned: Value(_num(r['changeReturned'])),
            extraCashTip: Value(_num(r['extraCashTip'])),
            distanceKm: Value(_num(r['distanceKm'])),
            address: Value(_str(r['address'])),
            notes: Value(_str(r['notes'])),
            createdAt: _dateTime(r['createdAt']),
            updatedAt: _dateTime(r['updatedAt']),
          ),
        );
      }
      for (final r in workTimeRows) {
        final date = _str(r['date']);
        if (date.isEmpty) continue;
        final companion = WorkTimesCompanion.insert(
          date: date,
          startTime: Value(_str(r['startTime'])),
          endTime: Value(_str(r['endTime'])),
          workHours: Value(_num(r['workHours'])),
        );
        b.insert(
          db.workTimes,
          companion,
          onConflict: DoUpdate((_) => companion, target: [db.workTimes.date]),
        );
      }
    });
  });

  return ImportResult(orders: orderRows.length, workTimes: workTimeRows.length);
}

List<Map<String, CellValue?>> _readRowsByHeader(Sheet? sheet) {
  if (sheet == null || sheet.rows.isEmpty) return const [];
  final header = sheet.rows.first;
  final names = <String>[for (final cell in header) _str(cell?.value).trim()];
  final out = <Map<String, CellValue?>>[];
  for (var i = 1; i < sheet.rows.length; i++) {
    final row = sheet.rows[i];
    if (row.every((c) => c?.value == null)) continue;
    final map = <String, CellValue?>{};
    for (var j = 0; j < names.length && j < row.length; j++) {
      if (names[j].isEmpty) continue;
      map[names[j]] = row[j]?.value;
    }
    out.add(map);
  }
  return out;
}

String _str(Object? v) {
  if (v == null) return '';
  if (v is TextCellValue) return v.value.toString();
  if (v is IntCellValue) return v.value.toString();
  if (v is DoubleCellValue) {
    final d = v.value;
    return d == d.truncateToDouble() ? d.toInt().toString() : d.toString();
  }
  if (v is DateCellValue) {
    return '${v.year.toString().padLeft(4, '0')}-'
        '${v.month.toString().padLeft(2, '0')}-'
        '${v.day.toString().padLeft(2, '0')}';
  }
  if (v is BoolCellValue) return v.value.toString();
  if (v is FormulaCellValue) return v.formula;
  return v.toString();
}

String _strOr(CellValue? v, String fallback) {
  final s = _str(v);
  return s.isEmpty ? fallback : s;
}

double _num(CellValue? v) {
  if (v == null) return 0;
  if (v is DoubleCellValue) return v.value;
  if (v is IntCellValue) return v.value.toDouble();
  if (v is TextCellValue) {
    return double.tryParse(v.value.toString().trim()) ?? 0;
  }
  return 0;
}

Value<DateTime> _dateTime(CellValue? v) {
  final s = _str(v).trim();
  if (s.isEmpty) return const Value.absent();
  final parsed = DateTime.tryParse(s);
  return parsed == null ? const Value.absent() : Value(parsed);
}
