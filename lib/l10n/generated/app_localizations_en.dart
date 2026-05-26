// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trip Wage';

  @override
  String get navDashboard => 'Today';

  @override
  String get navTrips => 'Trips';

  @override
  String get navStats => 'Stats';

  @override
  String get navLeaderboard => 'Ranking';

  @override
  String get navProfile => 'Settings';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSaving => 'Saving…';

  @override
  String get commonSaved => 'Saved';

  @override
  String get commonToday => 'Today';

  @override
  String get commonBackToToday => 'Back to today';

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
      other: 'Today\'s orders ($count)',
      zero: 'No orders today',
    );
    return '$_temp0';
  }

  @override
  String get dashboardEmpty => 'No orders';

  @override
  String get dashboardTotalIncome => 'Today\'s Total';

  @override
  String get dashboardBaseAndFuel => 'Base + Fuel';

  @override
  String get dashboardTips => 'Tips';

  @override
  String get dashboardOrders => 'Orders';

  @override
  String get dashboardDistance => 'Distance';

  @override
  String get dashboardHourlyRate => 'Hourly';

  @override
  String get dashboardWorkTime => 'Work time';

  @override
  String get dashboardStart => 'Start';

  @override
  String get dashboardEnd => 'End';

  @override
  String get dashboardLongTrip => 'Long';

  @override
  String get dashboardYouOweRestaurant => 'You owe restaurant';

  @override
  String get dashboardRestaurantOwesYou => 'Restaurant owes you';

  @override
  String get dashboardCashOrders => 'Cash orders';

  @override
  String get dashboardTipsFromRestaurant => 'Tips from restaurant';

  @override
  String get tripsFilterLast7 => 'Last 7 days';

  @override
  String get tripsFilterLast14 => 'Last 14 days';

  @override
  String get tripsFilterLast30 => 'Last 30 days';

  @override
  String get tripsFilterLast90 => 'Last 90 days';

  @override
  String get tripsFilterAll => 'All trips';

  @override
  String get statsPrevCycle => 'Prev cycle';

  @override
  String get statsCurrentCycle => 'Current';

  @override
  String get statsNextCycle => 'Next cycle';

  @override
  String get statsWorkingDays => 'Working days';

  @override
  String get statsTotalOrders => 'Total orders';

  @override
  String get statsTotalWorkHours => 'Work hours';

  @override
  String get statsAvgHourly => 'Avg hourly';

  @override
  String get statsBasePay => 'Base pay';

  @override
  String get statsFuelSubsidy => 'Fuel subsidy';

  @override
  String get statsBiweeklyPay => 'Biweekly paycheck';

  @override
  String get statsTotalEarnings => 'Total earnings';

  @override
  String get statsDailyBreakdown => 'Daily wage breakdown';

  @override
  String get statsComposition => 'Income composition';

  @override
  String get statsDays => 'days';

  @override
  String get statsNoData => 'No data in this range';

  @override
  String get paymentOnline => 'Online';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentMixed => 'Mixed';

  @override
  String get orderAddTitle => 'Add Order';

  @override
  String get orderEditTitle => 'Edit Order';

  @override
  String get orderAdd => 'Add';

  @override
  String get orderNumber => 'Order #';

  @override
  String get orderPaymentType => 'Payment';

  @override
  String get orderValue => 'Order Value';

  @override
  String get orderTip => 'Tip';

  @override
  String get orderPaymentAmount => 'Payment Amt';

  @override
  String get orderChange => 'Change';

  @override
  String get orderExtraCashTip => 'Extra Cash Tip';

  @override
  String get orderDistance => 'Distance (km)';

  @override
  String get orderAddress => 'Address';

  @override
  String get orderNotes => 'Notes';

  @override
  String get orderDeleteConfirmTitle => 'Delete this order?';

  @override
  String get orderDeleteConfirmMsg => 'This action cannot be undone.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsWageSection => 'Wage Calculation';

  @override
  String get settingsBaseHourlyRate => 'Base hourly rate (\$)';

  @override
  String get settingsFuelPerOrder => 'Fuel per order (\$)';

  @override
  String get settingsLongTripThresholdKm => 'Long trip threshold (km)';

  @override
  String get settingsLongTripExtraFuel => 'Long trip extra fuel (\$)';

  @override
  String get settingsBiweeklySettlementDays => 'Biweekly settlement days';

  @override
  String get settingsBiweeklyAnchorDate => 'Biweekly anchor date';

  @override
  String get settingsPreferencesSection => 'Preferences';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsThemeMode => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLangZh => '中文';

  @override
  String get settingsLangEn => 'English';

  @override
  String get settingsReset => 'Reset to defaults';

  @override
  String get settingsResetConfirmTitle => 'Reset settings?';

  @override
  String get settingsResetConfirmMsg => 'All settings will be restored to defaults.';

  @override
  String get leaderboardSearchHint => 'Search address';

  @override
  String leaderboardOrders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardAvgTip => 'avg tip';

  @override
  String get leaderboardEmpty => 'No addresses with tips yet';

  @override
  String get leaderboardNoAddress => '(no address)';

  @override
  String get settingsDataSection => 'Data';

  @override
  String get settingsImportBackup => 'Import backup (.json)';

  @override
  String get settingsImportHint => 'Import orders & work times exported from MongoDB';

  @override
  String settingsImportSuccess(int orders, int workTimes) {
    return 'Imported $orders orders, $workTimes work times';
  }

  @override
  String settingsImportFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get settingsMigrateNotes => 'Copy notes → address';

  @override
  String get settingsMigrateNotesHint => 'Only fills address when it\'s empty; notes are kept';

  @override
  String get settingsMigrateNotesConfirm => 'Copy notes content into the address field for orders whose address is empty? Notes will be kept as-is.';

  @override
  String settingsMigrateNotesResult(int count) {
    return 'Updated $count orders';
  }

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsVersion => 'Version';
}
