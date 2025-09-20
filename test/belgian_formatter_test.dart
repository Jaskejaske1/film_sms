import 'package:flutter_test/flutter_test.dart';
import 'package:film_sms/core/utils/belgian_formatter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nl_BE', null);
    await initializeDateFormatting('nl', null);
  });

  group('BelgianFormatter labels', () {
    test('formatListLabel today shows time only', () {
      final now = DateTime.now();
      final label = BelgianFormatter.formatListLabel(now);
      expect(label.contains('u'), true);
    });

    test('formatListLabel within last 7 days shows weekday + time', () {
      final ts = DateTime.now().subtract(const Duration(days: 2, hours: 3));
      final label = BelgianFormatter.formatListLabel(ts);
      expect(RegExp(r'^[a-z]{2,3} ').hasMatch(label), true);
      expect(label.contains('u'), true);
    });

    test('formatListLabel same year older shows dd/MM', () {
      final now = DateTime.now();
      final month = now.month == 1 ? 2 : now.month - 1;
      final ts = DateTime(now.year, month, now.day);
      final label = BelgianFormatter.formatListLabel(ts);
      // dd/MM -> contains a single slash, no year
      expect(label.contains('/'), true);
      expect(label.length, 5);
    });

    test('formatBubbleLabel older shows date + time', () {
      final ts = DateTime(2020, 1, 15, 7, 30);
      final label = BelgianFormatter.formatBubbleLabel(ts);
      expect(label.contains('2020'), true);
      expect(label.contains('u'), true);
    });
  });
}
