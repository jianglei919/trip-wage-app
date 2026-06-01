// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppL10nZh extends AppL10n {
  AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Trip Wage';

  @override
  String get navDashboard => '今日';

  @override
  String get navTrips => '行程';

  @override
  String get navStats => '统计';

  @override
  String get navLeaderboard => '排行';

  @override
  String get navProfile => '设置';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonDelete => '删除';

  @override
  String get commonExport => '导出';

  @override
  String get commonSaving => '保存中…';

  @override
  String get commonSaved => '已保存';

  @override
  String get commonToday => '今天';

  @override
  String get commonBackToToday => '回到今天';

  @override
  String get commonHours => 'h';

  @override
  String get commonKm => 'km';

  @override
  String get commonNone => '—';

  @override
  String dashboardTodayOrders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '当日订单 ($count)',
      zero: '今日暂无订单',
    );
    return '$_temp0';
  }

  @override
  String get dashboardEmpty => '暂无订单';

  @override
  String get dashboardTotalIncome => '今日总收入';

  @override
  String get dashboardBaseAndFuel => '底薪+油费';

  @override
  String get dashboardTips => '小费';

  @override
  String get dashboardOrders => '订单';

  @override
  String get dashboardDistance => '里程';

  @override
  String get dashboardHourlyRate => '时薪';

  @override
  String get dashboardWorkTime => '工时';

  @override
  String get dashboardStart => '开始';

  @override
  String get dashboardEnd => '结束';

  @override
  String get dashboardClearedStart => '已清空开始时间';

  @override
  String get dashboardClearedEnd => '已清空结束时间';

  @override
  String get commonUndo => '撤销';

  @override
  String get dashboardLongTrip => '长单';

  @override
  String get dashboardYouOweRestaurant => '你需要付给餐馆';

  @override
  String get dashboardRestaurantOwesYou => '餐馆需要付给你';

  @override
  String get dashboardCashOrders => '现金订单';

  @override
  String get dashboardTipsFromRestaurant => '餐馆小费';

  @override
  String get tripsFilterLast7 => '近 7 天';

  @override
  String get tripsFilterLast14 => '近 14 天';

  @override
  String get tripsFilterLast30 => '近 30 天';

  @override
  String get tripsFilterLast90 => '近 90 天';

  @override
  String get tripsFilterAll => '全部行程';

  @override
  String get statsPrevCycle => '上一周期';

  @override
  String get statsCurrentCycle => '当前周期';

  @override
  String get statsNextCycle => '下一周期';

  @override
  String get statsWorkingDays => '工作天数';

  @override
  String get statsTotalOrders => '总订单';

  @override
  String get statsTotalWorkHours => '总工时';

  @override
  String get statsAvgHourly => '平均时薪';

  @override
  String get statsBasePay => '底薪';

  @override
  String get statsFuelSubsidy => '油费补贴';

  @override
  String get statsBiweeklyPay => '双周工资';

  @override
  String get statsTotalEarnings => '总收入';

  @override
  String get statsDailyBreakdown => '每日工资构成';

  @override
  String get statsComposition => '收入构成';

  @override
  String get statsDays => '天';

  @override
  String get statsNoData => '此区间无数据';

  @override
  String get paymentOnline => '在线';

  @override
  String get paymentCard => '刷卡';

  @override
  String get paymentCash => '现金';

  @override
  String get paymentMixed => '混合';

  @override
  String get orderAddTitle => '添加订单';

  @override
  String get orderEditTitle => '编辑订单';

  @override
  String get orderAdd => '加单';

  @override
  String get orderDate => '日期';

  @override
  String get orderNumber => '单号';

  @override
  String get orderPaymentType => '支付方式';

  @override
  String get orderValue => '订单金额';

  @override
  String get orderTip => '小费';

  @override
  String get orderPaymentAmount => '实收金额';

  @override
  String get orderChange => '找零';

  @override
  String get orderExtraCashTip => '额外现金小费';

  @override
  String get orderDistance => '距离 (km)';

  @override
  String get orderAddress => '地址';

  @override
  String get orderNotes => '备注';

  @override
  String get orderDeleteConfirmTitle => '删除该订单？';

  @override
  String get orderDeleteConfirmMsg => '此操作不可撤销。';

  @override
  String get orderScanReceipt => '扫描收据自动填写';

  @override
  String get orderScanning => '识别中...';

  @override
  String get orderScanFromCamera => '拍照';

  @override
  String get orderScanFromGallery => '从相册选择';

  @override
  String get orderScanSuccess => '识别完成，请核对';

  @override
  String orderScanFailed(String error) {
    return '识别失败：$error';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsWageSection => '工资计算参数';

  @override
  String get settingsBaseHourlyRate => '基础时薪 (\$)';

  @override
  String get settingsFuelPerOrder => '每单油费 (\$)';

  @override
  String get settingsLongTripThresholdKm => '长单距离阈值 (km)';

  @override
  String get settingsLongTripExtraFuel => '长单额外油费 (\$)';

  @override
  String get settingsBiweeklySettlementDays => '双周结算周期 (天)';

  @override
  String get settingsBiweeklyAnchorDate => '双周周期锚点';

  @override
  String get settingsPreferencesSection => '偏好';

  @override
  String get settingsCurrency => '货币';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsThemeMode => '主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsLangZh => '中文';

  @override
  String get settingsLangEn => 'English';

  @override
  String get settingsReset => '恢复默认值';

  @override
  String get settingsResetConfirmTitle => '恢复默认设置？';

  @override
  String get settingsResetConfirmMsg => '所有设置将恢复为默认值。';

  @override
  String get leaderboardSearchHint => '搜索地址';

  @override
  String leaderboardOrders(int count) {
    return '$count 单';
  }

  @override
  String get leaderboardAvgTip => '均小费';

  @override
  String get leaderboardEmpty => '暂无带小费的地址';

  @override
  String get leaderboardNoAddress => '(无地址)';

  @override
  String get settingsDataSection => '数据';

  @override
  String get settingsImportBackup => '导入备份 (.shbak)';

  @override
  String get settingsImportHint => '用备份内容覆盖当前所有订单与工时';

  @override
  String get settingsImportConfirmTitle => '替换所有数据？';

  @override
  String get settingsImportConfirmMsg => '导入会先删除当前全部订单与工时，再从备份载入。此操作无法撤销。';

  @override
  String settingsImportSuccess(int orders, int workTimes) {
    return '已导入 $orders 条订单、$workTimes 条工时';
  }

  @override
  String settingsImportFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get settingsExportBackup => '导出备份 (.shbak)';

  @override
  String get settingsExportHint => '将全部订单与工时保存为 Excel 备份文件';

  @override
  String get settingsExportAllOrders => '导出全部订单 (.xlsx)';

  @override
  String get settingsExportAllOrdersHint => '将所有订单保存为单个 Excel 文件';

  @override
  String get settingsExportAllConfirmTitle => '导出全部订单？';

  @override
  String settingsExportAllConfirmMsg(int count) {
    return '将 $count 条订单导出为 Excel？';
  }

  @override
  String get settingsExportByDate => '按日期导出 (.xlsx)';

  @override
  String get settingsExportByDateHint => '选择某天导出该日订单';

  @override
  String settingsExportOrdersSuccess(int count, String filename) {
    return '已导出 $count 条订单 → $filename';
  }

  @override
  String get settingsExportNoOrders => '暂无可导出的订单';

  @override
  String settingsExportSuccess(int orders, int workTimes) {
    return '已导出 $orders 条订单、$workTimes 条工时';
  }

  @override
  String settingsExportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String get settingsAboutSection => '关于';

  @override
  String get settingsVersion => '版本';
}
