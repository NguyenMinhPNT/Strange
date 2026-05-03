import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Strange'**
  String get appName;

  /// No description provided for @tabLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get tabLearning;

  /// No description provided for @tabProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get tabProjects;

  /// No description provided for @tabHabits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get tabHabits;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @editCard.
  ///
  /// In en, this message translates to:
  /// **'Edit Card'**
  String get editCard;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCard;

  /// No description provided for @archiveCard.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveCard;

  /// No description provided for @restoreCard.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get restoreCard;

  /// No description provided for @cardNameHint.
  ///
  /// In en, this message translates to:
  /// **'Card name'**
  String get cardNameHint;

  /// No description provided for @cardNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get cardNameLabel;

  /// No description provided for @cardArchived.
  ///
  /// In en, this message translates to:
  /// **'Card archived'**
  String get cardArchived;

  /// No description provided for @noCardsYet.
  ///
  /// In en, this message translates to:
  /// **'No cards yet. Tap + to add one!'**
  String get noCardsYet;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteCardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this card?'**
  String get deleteCardConfirm;

  /// No description provided for @deleteCardMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the card and all its sessions.'**
  String get deleteCardMessage;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @deepWork.
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get deepWork;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startSession;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @skipBreak.
  ///
  /// In en, this message translates to:
  /// **'Skip Break'**
  String get skipBreak;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endSession;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'FOCUS'**
  String get focus;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'SHORT BREAK'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'LONG BREAK'**
  String get longBreak;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @pomodoroTimer.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Timer'**
  String get pomodoroTimer;

  /// No description provided for @deepWorkTimer.
  ///
  /// In en, this message translates to:
  /// **'Deep Work Timer'**
  String get deepWorkTimer;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @workDuration.
  ///
  /// In en, this message translates to:
  /// **'Work Session'**
  String get workDuration;

  /// No description provided for @shortBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreakDuration;

  /// No description provided for @longBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreakDuration;

  /// No description provided for @roundsBeforeLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Rounds Before Long Break'**
  String get roundsBeforeLongBreak;

  /// No description provided for @maxPauseDuration.
  ///
  /// In en, this message translates to:
  /// **'Max Pause Duration'**
  String get maxPauseDuration;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @vibrate.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get vibrate;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @range7Days.
  ///
  /// In en, this message translates to:
  /// **'7D'**
  String get range7Days;

  /// No description provided for @range1Month.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get range1Month;

  /// No description provided for @range3Months.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get range3Months;

  /// No description provided for @range1Year.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get range1Year;

  /// No description provided for @noStats.
  ///
  /// In en, this message translates to:
  /// **'Start a session to see your insights here'**
  String get noStats;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get seconds;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hours;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsCount;

  /// No description provided for @customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customColor;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
