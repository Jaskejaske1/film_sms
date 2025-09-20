import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('nl'),
  ];

  /// App title shown in the app bar and system.
  ///
  /// In nl, this message translates to:
  /// **'Berichten'**
  String get appTitle;

  /// Label for conversations list.
  ///
  /// In nl, this message translates to:
  /// **'Gesprekken'**
  String get conversations;

  /// Action to start a new message.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw bericht'**
  String get newMessage;

  /// Action to delete a conversation.
  ///
  /// In nl, this message translates to:
  /// **'Gesprek verwijderen'**
  String get deleteConversation;

  /// Name of the De Lijn template.
  ///
  /// In nl, this message translates to:
  /// **'De Lijn Bus Ticket'**
  String get deLijnTemplate;

  /// Label for price input.
  ///
  /// In nl, this message translates to:
  /// **'Prijs'**
  String get price;

  /// Currency label euro.
  ///
  /// In nl, this message translates to:
  /// **'euro'**
  String get euro;

  /// Generic action to inject/insert.
  ///
  /// In nl, this message translates to:
  /// **'Invoegen'**
  String get inject;

  /// Generic loading text.
  ///
  /// In nl, this message translates to:
  /// **'Laden...'**
  String get loading;

  /// Generic error label.
  ///
  /// In nl, this message translates to:
  /// **'Fout'**
  String get error;

  /// No description provided for @errorWithMessage.
  ///
  /// In nl, this message translates to:
  /// **'Fout: {message}'**
  String errorWithMessage(String message);

  /// Fallback name when contact unknown.
  ///
  /// In nl, this message translates to:
  /// **'Onbekend'**
  String get unknownContact;

  /// Menu item: inject De Lijn message.
  ///
  /// In nl, this message translates to:
  /// **'Inject De Lijn'**
  String get menuInjectDeLijn;

  /// Menu item: inject from template.
  ///
  /// In nl, this message translates to:
  /// **'Inject Template…'**
  String get menuInjectTemplate;

  /// Menu item: wipe local data.
  ///
  /// In nl, this message translates to:
  /// **'Data wissen'**
  String get menuWipeData;

  /// Snackbar text shown after wiping data.
  ///
  /// In nl, this message translates to:
  /// **'Data gewist en opnieuw geconfigureerd.'**
  String get dataWiped;

  /// Snackbar text after wipe on mobile suggesting to restart the app.
  ///
  /// In nl, this message translates to:
  /// **'Data gewist — herstart de app voor een propere sessie.'**
  String get dataWipedMobile;

  /// Desktop-only menu item to hard reset data and exit the app.
  ///
  /// In nl, this message translates to:
  /// **'Harde reset + afsluiten'**
  String get menuHardResetExit;

  /// Dialog title requesting user input for template variables.
  ///
  /// In nl, this message translates to:
  /// **'Vul gegevens in'**
  String get fillInData;

  /// Generic cancel button text.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get cancel;

  /// Generic OK button text.
  ///
  /// In nl, this message translates to:
  /// **'OK'**
  String get ok;

  /// Validation message for required fields.
  ///
  /// In nl, this message translates to:
  /// **'Verplicht'**
  String get required;

  /// Hint text in the message composer input field.
  ///
  /// In nl, this message translates to:
  /// **'Typ een bericht…'**
  String get typeMessageHint;

  /// Info text explaining that template injection is accessible via long-press on a conversation.
  ///
  /// In nl, this message translates to:
  /// **'Template-injectie wordt via long-press afgehandeld.'**
  String get templateInjectionHint;

  /// No description provided for @templateInsertedWithPreview.
  ///
  /// In nl, this message translates to:
  /// **'Template ingevoegd: {preview}...'**
  String templateInsertedWithPreview(String preview);

  /// No description provided for @deLijnInsertedWithPreview.
  ///
  /// In nl, this message translates to:
  /// **'De Lijn ingevoegd: {preview}...'**
  String deLijnInsertedWithPreview(String preview);

  /// No description provided for @insertErrorWithMessage.
  ///
  /// In nl, this message translates to:
  /// **'Fout bij invoegen: {message}'**
  String insertErrorWithMessage(String message);

  /// App bar menu item: open settings.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get menuSettings;

  /// Settings page title.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settingsTitle;

  /// Section label for language setting.
  ///
  /// In nl, this message translates to:
  /// **'Taal'**
  String get settingsLanguage;

  /// Use system locale.
  ///
  /// In nl, this message translates to:
  /// **'Systeemstandaard'**
  String get languageSystemDefault;

  /// English language option.
  ///
  /// In nl, this message translates to:
  /// **'Engels'**
  String get languageEnglish;

  /// Dutch language option.
  ///
  /// In nl, this message translates to:
  /// **'Nederlands'**
  String get languageDutch;
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
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
