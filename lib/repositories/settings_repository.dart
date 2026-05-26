import 'package:drift/drift.dart';

import '../core/db/database.dart';

/// 单行设置表的 Repository
/// id 恒为 1，由 Database 在首次创建时插入默认行
class SettingsRepository {
  SettingsRepository(this._db);
  final AppDatabase _db;

  Future<AppSetting> get() async {
    return _db.select(_db.appSettings).getSingle();
  }

  Stream<AppSetting> watch() {
    return _db.select(_db.appSettings).watchSingle();
  }

  /// 部分更新，未传字段保持不变
  Future<void> update({
    double? baseHourlyRate,
    double? fuelPerOrder,
    double? longTripThresholdKm,
    double? longTripExtraFuel,
    int? biweeklySettlementDays,
    String? biweeklyAnchorDate,
    String? currency,
    String? locale,
    String? themeMode,
  }) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        baseHourlyRate: baseHourlyRate == null
            ? const Value.absent()
            : Value(baseHourlyRate),
        fuelPerOrder:
            fuelPerOrder == null ? const Value.absent() : Value(fuelPerOrder),
        longTripThresholdKm: longTripThresholdKm == null
            ? const Value.absent()
            : Value(longTripThresholdKm),
        longTripExtraFuel: longTripExtraFuel == null
            ? const Value.absent()
            : Value(longTripExtraFuel),
        biweeklySettlementDays: biweeklySettlementDays == null
            ? const Value.absent()
            : Value(biweeklySettlementDays),
        biweeklyAnchorDate: biweeklyAnchorDate == null
            ? const Value.absent()
            : Value(biweeklyAnchorDate),
        currency: currency == null ? const Value.absent() : Value(currency),
        locale: locale == null ? const Value.absent() : Value(locale),
        themeMode: themeMode == null ? const Value.absent() : Value(themeMode),
      ),
    );
  }

  Future<void> resetToDefaults() async {
    await (_db.delete(_db.appSettings)..where((t) => t.id.equals(1))).go();
    await _db.into(_db.appSettings).insert(AppSettingsCompanion.insert());
  }
}
