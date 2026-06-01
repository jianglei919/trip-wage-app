import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n? of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n);
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Wage'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navDashboard;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get navLeaderboard;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navProfile;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get commonExport;

  /// No description provided for @commonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get commonSaving;

  /// No description provided for @commonSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get commonSaved;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonBackToToday.
  ///
  /// In en, this message translates to:
  /// **'Back to today'**
  String get commonBackToToday;

  /// No description provided for @commonHours.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get commonHours;

  /// No description provided for @commonKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get commonKm;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get commonNone;

  /// No description provided for @dashboardTodayOrders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No orders today} other{Today\'s orders ({count})}}'**
  String dashboardTodayOrders(int count);

  /// No description provided for @dashboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get dashboardEmpty;

  /// No description provided for @dashboardTotalIncome.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Total'**
  String get dashboardTotalIncome;

  /// No description provided for @dashboardBaseAndFuel.
  ///
  /// In en, this message translates to:
  /// **'Base + Fuel'**
  String get dashboardBaseAndFuel;

  /// No description provided for @dashboardTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get dashboardTips;

  /// No description provided for @dashboardOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardOrders;

  /// No description provided for @dashboardDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get dashboardDistance;

  /// No description provided for @dashboardHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get dashboardHourlyRate;

  /// No description provided for @dashboardWorkTime.
  ///
  /// In en, this message translates to:
  /// **'Work time'**
  String get dashboardWorkTime;

  /// No description provided for @dashboardStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get dashboardStart;

  /// No description provided for @dashboardEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get dashboardEnd;

  /// No description provided for @dashboardClearedStart.
  ///
  /// In en, this message translates to:
  /// **'Cleared start time'**
  String get dashboardClearedStart;

  /// No description provided for @dashboardClearedEnd.
  ///
  /// In en, this message translates to:
  /// **'Cleared end time'**
  String get dashboardClearedEnd;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @dashboardLongTrip.
  ///
  /// In en, this message translates to:
  /// **'Long'**
  String get dashboardLongTrip;

  /// No description provided for @dashboardYouOweRestaurant.
  ///
  /// In en, this message translates to:
  /// **'You owe restaurant'**
  String get dashboardYouOweRestaurant;

  /// No description provided for @dashboardRestaurantOwesYou.
  ///
  /// In en, this message translates to:
  /// **'Restaurant owes you'**
  String get dashboardRestaurantOwesYou;

  /// No description provided for @dashboardCashOrders.
  ///
  /// In en, this message translates to:
  /// **'Cash orders'**
  String get dashboardCashOrders;

  /// No description provided for @dashboardTipsFromRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Tips from restaurant'**
  String get dashboardTipsFromRestaurant;

  /// No description provided for @tripsFilterLast7.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get tripsFilterLast7;

  /// No description provided for @tripsFilterLast14.
  ///
  /// In en, this message translates to:
  /// **'Last 14 days'**
  String get tripsFilterLast14;

  /// No description provided for @tripsFilterLast30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get tripsFilterLast30;

  /// No description provided for @tripsFilterLast90.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get tripsFilterLast90;

  /// No description provided for @tripsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All trips'**
  String get tripsFilterAll;

  /// No description provided for @statsPrevCycle.
  ///
  /// In en, this message translates to:
  /// **'Prev cycle'**
  String get statsPrevCycle;

  /// No description provided for @statsCurrentCycle.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get statsCurrentCycle;

  /// No description provided for @statsNextCycle.
  ///
  /// In en, this message translates to:
  /// **'Next cycle'**
  String get statsNextCycle;

  /// No description provided for @statsWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'Working days'**
  String get statsWorkingDays;

  /// No description provided for @statsTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get statsTotalOrders;

  /// No description provided for @statsTotalWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Work hours'**
  String get statsTotalWorkHours;

  /// No description provided for @statsAvgHourly.
  ///
  /// In en, this message translates to:
  /// **'Avg hourly'**
  String get statsAvgHourly;

  /// No description provided for @statsBasePay.
  ///
  /// In en, this message translates to:
  /// **'Base pay'**
  String get statsBasePay;

  /// No description provided for @statsFuelSubsidy.
  ///
  /// In en, this message translates to:
  /// **'Fuel subsidy'**
  String get statsFuelSubsidy;

  /// No description provided for @statsBiweeklyPay.
  ///
  /// In en, this message translates to:
  /// **'Biweekly paycheck'**
  String get statsBiweeklyPay;

  /// No description provided for @statsTotalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total earnings'**
  String get statsTotalEarnings;

  /// No description provided for @statsDailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Daily wage breakdown'**
  String get statsDailyBreakdown;

  /// No description provided for @statsComposition.
  ///
  /// In en, this message translates to:
  /// **'Income composition'**
  String get statsComposition;

  /// No description provided for @statsDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get statsDays;

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data in this range'**
  String get statsNoData;

  /// No description provided for @paymentOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get paymentOnline;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get paymentMixed;

  /// No description provided for @orderAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Order'**
  String get orderAddTitle;

  /// No description provided for @orderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Order'**
  String get orderEditTitle;

  /// No description provided for @orderAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get orderAdd;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get orderDate;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderNumber;

  /// No description provided for @orderPaymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get orderPaymentType;

  /// No description provided for @orderValue.
  ///
  /// In en, this message translates to:
  /// **'Order Value'**
  String get orderValue;

  /// No description provided for @orderTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get orderTip;

  /// No description provided for @orderPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amt'**
  String get orderPaymentAmount;

  /// No description provided for @orderChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get orderChange;

  /// No description provided for @orderExtraCashTip.
  ///
  /// In en, this message translates to:
  /// **'Extra Cash Tip'**
  String get orderExtraCashTip;

  /// No description provided for @orderDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get orderDistance;

  /// No description provided for @orderAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get orderAddress;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get orderNotes;

  /// No description provided for @orderDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this order?'**
  String get orderDeleteConfirmTitle;

  /// No description provided for @orderDeleteConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get orderDeleteConfirmMsg;

  /// No description provided for @orderScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan Receipt to Auto-fill'**
  String get orderScanReceipt;

  /// No description provided for @orderScanning.
  ///
  /// In en, this message translates to:
  /// **'Recognizing...'**
  String get orderScanning;

  /// No description provided for @orderScanFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get orderScanFromCamera;

  /// No description provided for @orderScanFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Album'**
  String get orderScanFromGallery;

  /// No description provided for @orderScanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recognition done, please verify'**
  String get orderScanSuccess;

  /// No description provided for @orderScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Recognition failed: {error}'**
  String orderScanFailed(String error);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsWageSection.
  ///
  /// In en, this message translates to:
  /// **'Wage Calculation'**
  String get settingsWageSection;

  /// No description provided for @settingsBaseHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Base hourly rate (\$)'**
  String get settingsBaseHourlyRate;

  /// No description provided for @settingsFuelPerOrder.
  ///
  /// In en, this message translates to:
  /// **'Fuel per order (\$)'**
  String get settingsFuelPerOrder;

  /// No description provided for @settingsLongTripThresholdKm.
  ///
  /// In en, this message translates to:
  /// **'Long trip threshold (km)'**
  String get settingsLongTripThresholdKm;

  /// No description provided for @settingsLongTripExtraFuel.
  ///
  /// In en, this message translates to:
  /// **'Long trip extra fuel (\$)'**
  String get settingsLongTripExtraFuel;

  /// No description provided for @settingsBiweeklySettlementDays.
  ///
  /// In en, this message translates to:
  /// **'Biweekly settlement days'**
  String get settingsBiweeklySettlementDays;

  /// No description provided for @settingsBiweeklyAnchorDate.
  ///
  /// In en, this message translates to:
  /// **'Biweekly anchor date'**
  String get settingsBiweeklyAnchorDate;

  /// No description provided for @settingsPreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferencesSection;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLangZh.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get settingsLangZh;

  /// No description provided for @settingsLangEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEn;

  /// No description provided for @settingsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get settingsReset;

  /// No description provided for @settingsResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset settings?'**
  String get settingsResetConfirmTitle;

  /// No description provided for @settingsResetConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'All settings will be restored to defaults.'**
  String get settingsResetConfirmMsg;

  /// No description provided for @leaderboardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search address'**
  String get leaderboardSearchHint;

  /// No description provided for @leaderboardOrders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 order} other{{count} orders}}'**
  String leaderboardOrders(int count);

  /// No description provided for @leaderboardAvgTip.
  ///
  /// In en, this message translates to:
  /// **'avg tip'**
  String get leaderboardAvgTip;

  /// No description provided for @leaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No addresses with tips yet'**
  String get leaderboardEmpty;

  /// No description provided for @leaderboardNoAddress.
  ///
  /// In en, this message translates to:
  /// **'(no address)'**
  String get leaderboardNoAddress;

  /// No description provided for @settingsDataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsDataSection;

  /// No description provided for @settingsImportBackup.
  ///
  /// In en, this message translates to:
  /// **'Import backup (.shbak)'**
  String get settingsImportBackup;

  /// No description provided for @settingsImportHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces ALL current orders & work times with the backup contents'**
  String get settingsImportHint;

  /// No description provided for @settingsImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get settingsImportConfirmTitle;

  /// No description provided for @settingsImportConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Importing will delete every current order and work time, then load the backup. This cannot be undone.'**
  String get settingsImportConfirmMsg;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {orders} orders, {workTimes} work times'**
  String settingsImportSuccess(int orders, int workTimes);

  /// No description provided for @settingsImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String settingsImportFailed(String error);

  /// No description provided for @settingsExportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup (.shbak)'**
  String get settingsExportBackup;

  /// No description provided for @settingsExportHint.
  ///
  /// In en, this message translates to:
  /// **'Save all orders & work times as an Excel backup'**
  String get settingsExportHint;

  /// No description provided for @settingsExportAllOrders.
  ///
  /// In en, this message translates to:
  /// **'Export all orders (.xlsx)'**
  String get settingsExportAllOrders;

  /// No description provided for @settingsExportAllOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Save every order to a single Excel file'**
  String get settingsExportAllOrdersHint;

  /// No description provided for @settingsExportAllConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Export all orders?'**
  String get settingsExportAllConfirmTitle;

  /// No description provided for @settingsExportAllConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Export {count} orders to Excel?'**
  String settingsExportAllConfirmMsg(int count);

  /// No description provided for @settingsExportByDate.
  ///
  /// In en, this message translates to:
  /// **'Export by date (.xlsx)'**
  String get settingsExportByDate;

  /// No description provided for @settingsExportByDateHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and export that day\'s orders'**
  String get settingsExportByDateHint;

  /// No description provided for @settingsExportOrdersSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported {count} orders → {filename}'**
  String settingsExportOrdersSuccess(int count, String filename);

  /// No description provided for @settingsExportNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders to export'**
  String get settingsExportNoOrders;

  /// No description provided for @settingsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported {orders} orders, {workTimes} work times'**
  String settingsExportSuccess(int orders, int workTimes);

  /// No description provided for @settingsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String settingsExportFailed(String error);

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppL10nEn();
    case 'zh': return AppL10nZh();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
