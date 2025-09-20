class BelgianConstants {
  // Phone formatting
  static const String countryCode = '+32';
  static const String deLijnNumber = '+32488414';

  // Date/Time formatting
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH\'u\'mm'; // 07u56 format

  // Currency
  static const String currencySymbol = 'euro';
  static const String decimalSeparator = ','; // Belgian uses comma

  // De Lijn Template
  static const String deLijnCompany = 'De Lijn';
  static const String deLijnFooter = '**Onze App = Extra gemak!**';
  static const String deLijnTemplateFormat =
      '{{prefix_code}} Geldig op alle voertuigen van {{company}} tot {{expiry_time}} op {{current_date}}. Prijs: {{price}} euro {{validation_code}} {{footer}}';

  // Code generation
  static const int prefixCodeLength = 4; // XX*XX format
  static const int validationCodeLength = 23;
  static const String codeCharacters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  // Belgian regions for realistic data
  static const List<String> belgianCities = [
    'Antwerpen',
    'Gent',
    'Charleroi',
    'Liège',
    'Bruxelles',
    'Bruges',
    'Namur',
    'Leuven',
    'Mons',
    'Aalst',
    'Mechelen',
    'La Louvière',
  ];

  static const List<String> belgianCarriers = [
    'Proximus',
    'Telenet',
    'Base',
    'Orange Belgium',
  ];

  static const List<String> belgianServices = [
    'NMBS',
    'bpost',
    'Electrabel',
    'Luminus',
    'Colruyt',
    'Delhaize',
  ];
}
