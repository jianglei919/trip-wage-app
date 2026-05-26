import 'package:drift/drift.dart';

import 'db/database.dart';

/// 把 notes 内容拷贝到 address（仅在 address 为空且 notes 非空时）
/// 返回被更新的订单数
Future<int> copyNotesToEmptyAddress(AppDatabase db) async {
  return (db.update(db.orders)
        ..where((t) => t.address.equals('') & t.notes.isNotValue('')))
      .write(
    OrdersCompanion.custom(
      address: db.orders.notes,
      updatedAt: Variable(DateTime.now()),
    ),
  );
}
