import 'package:flutter_test/flutter_test.dart';
import 'package:film_sms/core/utils/belgian_phone_generator.dart';

void main() {
  test('Deterministic generator produces stable Belgian-style numbers', () {
    const seed = 'Mama';
    final n1 = BelgianPhoneGenerator.generateForSeed(seed);
    final n2 = BelgianPhoneGenerator.generateForSeed(seed);
    expect(n1, n2);
    expect(n1.startsWith('+32'), true);
    expect(n1.length, greaterThanOrEqualTo(12));
    // ensure looks like +32 4XX XXXXXX (no spaces in generator output)
    expect(n1.substring(3, 4), '4');
  });
}
