// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Berichten';

  @override
  String get conversations => 'Gesprekken';

  @override
  String get newMessage => 'Nieuw bericht';

  @override
  String get deleteConversation => 'Gesprek verwijderen';

  @override
  String get deLijnTemplate => 'De Lijn Bus Ticket';

  @override
  String get price => 'Prijs';

  @override
  String get euro => 'euro';

  @override
  String get inject => 'Invoegen';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fout';

  @override
  String errorWithMessage(String message) {
    return 'Fout: $message';
  }

  @override
  String get unknownContact => 'Onbekend';

  @override
  String get menuInjectDeLijn => 'Inject De Lijn';

  @override
  String get menuInjectTemplate => 'Inject Template…';

  @override
  String get menuWipeData => 'Data wissen';

  @override
  String get dataWiped => 'Data gewist en opnieuw geconfigureerd.';

  @override
  String get dataWipedMobile =>
      'Data gewist — herstart de app voor een propere sessie.';

  @override
  String get menuHardResetExit => 'Harde reset + afsluiten';

  @override
  String get fillInData => 'Vul gegevens in';

  @override
  String get cancel => 'Annuleren';

  @override
  String get ok => 'OK';

  @override
  String get required => 'Verplicht';

  @override
  String get typeMessageHint => 'Typ een bericht…';

  @override
  String get templateInjectionHint =>
      'Template-injectie wordt via long-press afgehandeld.';

  @override
  String templateInsertedWithPreview(String preview) {
    return 'Template ingevoegd: $preview...';
  }

  @override
  String deLijnInsertedWithPreview(String preview) {
    return 'De Lijn ingevoegd: $preview...';
  }

  @override
  String insertErrorWithMessage(String message) {
    return 'Fout bij invoegen: $message';
  }

  @override
  String get menuSettings => 'Instellingen';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get languageSystemDefault => 'Systeemstandaard';

  @override
  String get languageEnglish => 'Engels';

  @override
  String get languageDutch => 'Nederlands';
}
