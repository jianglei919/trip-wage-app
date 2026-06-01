import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Orders, WorkTimes, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// 测试用：传入内存或自定义 executor
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // 插入默认设置行
          await into(appSettings).insert(
            AppSettingsCompanion.insert(),
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(orders, orders.address);
          }
          if (from < 3) {
            // 把之前默认的 'USD' 升级到新的默认 'CAD'
            await (update(appSettings)
                  ..where((t) => t.currency.equals('USD')))
                .write(const AppSettingsCompanion(currency: Value('CAD')));
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'trip_wage.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
