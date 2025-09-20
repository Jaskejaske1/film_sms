// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Messages';

  @override
  String get conversations => 'Conversations';

  @override
  String get newMessage => 'New message';

  @override
  String get deleteConversation => 'Delete conversation';

  @override
  String get deLijnTemplate => 'De Lijn Bus Ticket';

  @override
  String get price => 'Price';

  @override
  String get euro => 'euro';

  @override
  String get inject => 'Insert';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get unknownContact => 'Unknown';

  @override
  String get menuInjectDeLijn => 'Inject De Lijn';

  @override
  String get menuInjectTemplate => 'Insert Template…';

  @override
  String get menuWipeData => 'Wipe data';

  @override
  String get dataWiped => 'Data wiped and reconfigured.';

  @override
  String get dataWipedMobile =>
      'Data wiped — restart the app for a clean session.';

  @override
  String get menuHardResetExit => 'Hard reset + exit';

  @override
  String get fillInData => 'Fill in data';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get required => 'Required';

  @override
  String get typeMessageHint => 'Type a message…';

  @override
  String get templateInjectionHint =>
      'Template injection is available via long-press.';

  @override
  String templateInsertedWithPreview(String preview) {
    return 'Template inserted: $preview...';
  }

  @override
  String deLijnInsertedWithPreview(String preview) {
    return 'De Lijn inserted: $preview...';
  }

  @override
  String insertErrorWithMessage(String message) {
    return 'Insert error: $message';
  }

  @override
  String get menuSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDutch => 'Dutch';
}
