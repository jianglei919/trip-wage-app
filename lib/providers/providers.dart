import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/db/database.dart';
import '../repositories/order_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/worktime_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(ref.watch(databaseProvider)),
);

final workTimeRepositoryProvider = Provider<WorkTimeRepository>(
  (ref) => WorkTimeRepository(ref.watch(databaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

/// 监听设置（用于全局响应：主题、语言、工资计算参数）
final settingsStreamProvider = StreamProvider<AppSetting>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// Dashboard 当前查看的日期；从其他页面也能改它来跳转
final currentDateProvider = StateProvider<String>((_) {
  final n = DateTime.now();
  final m = n.month.toString().padLeft(2, '0');
  final d = n.day.toString().padLeft(2, '0');
  return '${n.year}-$m-$d';
});
