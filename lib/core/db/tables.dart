import 'package:drift/drift.dart';

/// 订单 / 行程
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 'YYYY-MM-DD'
  TextColumn get date => text()();

  TextColumn get orderNumber => text().withDefault(const Constant(''))();

  /// online | cash | card | mixed
  TextColumn get paymentType => text().withDefault(const Constant('online'))();

  RealColumn get orderValue => real().withDefault(const Constant(0))();
  RealColumn get paymentAmount => real().withDefault(const Constant(0))();
  RealColumn get changeReturned => real().withDefault(const Constant(0))();
  RealColumn get extraCashTip => real().withDefault(const Constant(0))();
  RealColumn get distanceKm => real().withDefault(const Constant(0))();

  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// 每日工时（每天唯一）
class WorkTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()();
  TextColumn get startTime => text().withDefault(const Constant(''))();
  TextColumn get endTime => text().withDefault(const Constant(''))();
  RealColumn get workHours => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// 应用设置（单行，id 恒为 1）
/// 包含原来 wageConfig.js 的全部参数 + 用户偏好
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  // 工资计算参数（对应原 wageConfig.js）
  RealColumn get baseHourlyRate => real().withDefault(const Constant(8.5))();
  RealColumn get fuelPerOrder => real().withDefault(const Constant(3.5))();
  RealColumn get longTripThresholdKm =>
      real().withDefault(const Constant(10))();
  RealColumn get longTripExtraFuel => real().withDefault(const Constant(3.5))();
  IntColumn get biweeklySettlementDays =>
      integer().withDefault(const Constant(14))();
  TextColumn get biweeklyAnchorDate =>
      text().withDefault(const Constant('2026-04-20'))();

  // 用户偏好
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get locale => text().withDefault(const Constant('zh'))(); // zh | en
  TextColumn get themeMode =>
      text().withDefault(const Constant('system'))(); // system | light | dark

  @override
  Set<Column> get primaryKey => {id};
}
