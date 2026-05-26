import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import 'db/database.dart';

class ImportResult {
  const ImportResult({required this.orders, required this.workTimes});
  final int orders;
  final int workTimes;
}

/// 从导出的 JSON 文件批量导入到本地 SQLite
/// - orders 全部 insert（不去重，按订单号 + 日期不强制唯一）
/// - workTimes 用 upsert（按 date 唯一）
Future<ImportResult> importBackupFromFile(AppDatabase db, File file) async {
  final text = await file.readAsString();
  return importBackupFromJson(db, text);
}

Future<ImportResult> importBackupFromJson(AppDatabase db, String json) async {
  final data = jsonDecode(json) as Map<String, dynamic>;
  final ordersJson = (data['orders'] as List?) ?? const [];
  final workTimesJson = (data['workTimes'] as List?) ?? const [];

  await db.batch((b) {
    for (final raw in ordersJson) {
      final o = raw as Map<String, dynamic>;
      b.insert(
        db.orders,
        OrdersCompanion.insert(
          date: o['date'] as String,
          orderNumber: Value(o['orderNumber'] as String? ?? ''),
          paymentType: Value(o['paymentType'] as String? ?? 'online'),
          orderValue: Value(_d(o['orderValue'])),
          paymentAmount: Value(_d(o['paymentAmount'])),
          changeReturned: Value(_d(o['changeReturned'])),
          extraCashTip: Value(_d(o['extraCashTip'])),
          distanceKm: Value(_d(o['distanceKm'])),
          address: Value(o['address'] as String? ?? ''),
          notes: Value(o['notes'] as String? ?? ''),
          createdAt: o['createdAt'] != null
              ? Value(DateTime.parse(o['createdAt'] as String))
              : const Value.absent(),
          updatedAt: o['updatedAt'] != null
              ? Value(DateTime.parse(o['updatedAt'] as String))
              : const Value.absent(),
        ),
      );
    }
    for (final raw in workTimesJson) {
      final w = raw as Map<String, dynamic>;
      final companion = WorkTimesCompanion.insert(
        date: w['date'] as String,
        startTime: Value(w['startTime'] as String? ?? ''),
        endTime: Value(w['endTime'] as String? ?? ''),
        workHours: Value(_d(w['workHours'])),
      );
      b.insert(
        db.workTimes,
        companion,
        onConflict: DoUpdate(
          (_) => companion,
          target: [db.workTimes.date],
        ),
      );
    }
  });

  return ImportResult(
    orders: ordersJson.length,
    workTimes: workTimesJson.length,
  );
}

double _d(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}
