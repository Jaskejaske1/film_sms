import 'dart:math';
import '../constants/belgian_constants.dart';

class CodeGenerator {
  static final Random _random = Random();

  /// Generates a prefix code in format XX*XX (e.g., "14*N4", "AB*7C")
  static String generatePrefixCode() {
    final chars = BelgianConstants.codeCharacters;

    String getRandomChar() => chars[_random.nextInt(chars.length)];

    return '${getRandomChar()}${getRandomChar()}*${getRandomChar()}${getRandomChar()}';
  }

  /// Generates a validation code with specified length (default 23 chars)
  static String generateValidationCode({
    int length = BelgianConstants.validationCodeLength,
  }) {
    final chars = BelgianConstants.codeCharacters;
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(chars[_random.nextInt(chars.length)]);
    }

    return buffer.toString();
  }

  /// Generates a random Belgian phone number
  static String generateBelgianPhone() {
    // Belgian mobile numbers: +32 4XX XXX XXX
    final prefix = _random.nextBool() ? '46' : '47'; // Common mobile prefixes
    final middle = _random.nextInt(900) + 100; // 100-999
    final suffix = _random.nextInt(900) + 100; // 100-999

    return '+32 4$prefix $middle $suffix';
  }
}
