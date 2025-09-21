class BelgianPhoneGenerator {
  static const List<String> _mobilePrefixes = [
    '468',
    '471',
    '477',
    '465',
    '472',
  ];

  static int _hash(String s) {
    int h = 2166136261; // FNV-1a 32-bit base
    for (final codeUnit in s.codeUnits) {
      h ^= codeUnit;
      h = (h * 16777619) & 0xFFFFFFFF;
    }
    return h;
  }

  /// Generates a deterministic Belgian mobile number: '+32' + 9 digits
  /// in the pattern 4XX XXX XXX (no spaces in the returned value).
  static String generateForSeed(String seed) {
    final h = _hash(seed);
    final prefix = _mobilePrefixes[h % _mobilePrefixes.length];
    // Generate remaining 6 digits deterministically
    int x = h;
    final digits = List<int>.generate(6, (i) {
      x = (x * 1103515245 + 12345) & 0x7FFFFFFF; // LCG
      return (x % 10);
    });
    final tail = digits.map((d) => d.toString()).join();
    // Store without spaces; UI formatter will add spacing
    return '+32$prefix$tail';
  }
}
