import 'package:drift/drift.dart';

import '../core/db/database.dart';

/// 日汇总
class DailyStats {
  const DailyStats({
    required this.orderCount,
    required this.totalOrderValue,
    required this.totalCashTip,
    required this.totalDistanceKm,
  });

  final int orderCount;
  final double totalOrderValue;
  final double totalCashTip;
  final double totalDistanceKm;
}

class OrderRepository {
  OrderRepository(this._db);
  final AppDatabase _db;

  // 监听某一天的订单
  Stream<List<Order>> watchByDate(String date) {
    return (_db.select(_db.orders)
          ..where((t) => t.date.equals(date))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<List<Order>> getByDate(String date) {
    return (_db.select(_db.orders)..where((t) => t.date.equals(date))).get();
  }

  Future<List<Order>> getByDateRange(String startDate, String endDate) {
    return (_db.select(_db.orders)
          ..where((t) => t.date.isBetweenValues(startDate, endDate))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Future<int> insert(OrdersCompanion data) {
    return _db.into(_db.orders).insert(data);
  }

  Future<bool> update(Order order) {
    return _db.update(_db.orders).replace(
          order.copyWith(updatedAt: DateTime.now()),
        );
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.orders)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Order>> watchAll() {
    return (_db.select(_db.orders)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// 监听某区间所有订单
  Stream<List<Order>> watchByDateRange(String startDate, String endDate) {
    return (_db.select(_db.orders)
          ..where((t) => t.date.isBetweenValues(startDate, endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Future<DailyStats> getDailyStats(String date) async {
    final rows = await getByDate(date);
    double totalValue = 0, totalTip = 0, totalKm = 0;
    for (final o in rows) {
      totalValue += o.orderValue;
      totalTip += o.extraCashTip;
      totalKm += o.distanceKm;
    }
    return DailyStats(
      orderCount: rows.length,
      totalOrderValue: totalValue,
      totalCashTip: totalTip,
      totalDistanceKm: totalKm,
    );
  }
}
