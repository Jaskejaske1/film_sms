import 'package:intl/intl.dart';
import '../constants/belgian_constants.dart';

class BelgianFormatter {
  /// Formats date in Belgian format: DD/MM/YYYY
  static String formatDate(DateTime date) {
    final local = date.toLocal();
    final formatter = DateFormat(BelgianConstants.dateFormat, 'nl_BE');
    return formatter.format(local);
  }

  /// Formats date in Belgian format: DD/MM (no year)
  static String formatDateShort(DateTime date) {
    final local = date.toLocal();
    final formatter = DateFormat('dd/MM', 'nl_BE');
    return formatter.format(local);
  }

  /// Formats time in Belgian format: HHumm (e.g., "07u56")
  static String formatTime(DateTime time) {
    final local = time.toLocal();
    final formatter = DateFormat(BelgianConstants.timeFormat, 'nl_BE');
    return formatter.format(local);
  }

  /// Formats price in Belgian format: X,XX (comma as decimal separator)
  static String formatPrice(double price) {
    return price
        .toStringAsFixed(2)
        .replaceAll('.', BelgianConstants.decimalSeparator);
  }

  /// Gets current date + 1 hour in Belgian time format
  static String getExpiryTime() {
    final expiry = DateTime.now().toLocal().add(const Duration(hours: 1));
    return formatTime(expiry);
  }

  /// Gets current date in Belgian format
  static String getCurrentDate() {
    return formatDate(DateTime.now().toLocal());
  }

  /// Formats a Belgian phone number for display
  static String formatBelgianPhone(String phone) {
    // Remove all spaces and format consistently
    final cleaned = phone.replaceAll(' ', '');

    if (cleaned.startsWith('+32')) {
      // +32 4XX XXX XXX format
      if (cleaned.length >= 12) {
        final countryCode = cleaned.substring(0, 3);
        final areaCode = cleaned.substring(3, 6);
        final firstPart = cleaned.substring(6, 9);
        final secondPart = cleaned.substring(9, 12);
        return '$countryCode $areaCode $firstPart $secondPart';
      }
    }

    return phone; // Return original if can't format
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    final al = a.toLocal();
    final bl = b.toLocal();
    return al.year == bl.year && al.month == bl.month && al.day == bl.day;
  }

  static bool isWithinLastDays(DateTime date, int days) {
    final now = DateTime.now();
    final local = date.toLocal();
    final diff = now.difference(local);
    return !local.isAfter(now) && diff.inDays < days;
  }

  static String weekdayShort(DateTime date) {
    final local = date.toLocal();
    var wd = DateFormat('EEE', 'nl_BE').format(local);
    if (wd.endsWith('.')) wd = wd.substring(0, wd.length - 1);
    return wd.toLowerCase();
  }

  // Label for conversation list tiles (compact)
  static String formatListLabel(DateTime ts) {
    final now = DateTime.now();
    if (_isSameDay(ts, now)) return formatTime(ts);
    if (isWithinLastDays(ts, 7)) {
      return '${weekdayShort(ts)} ${formatTime(ts)}';
    }
    if (now.year == ts.toLocal().year) return formatDateShort(ts);
    return formatDate(ts);
  }

  // Label for message bubbles (more explicit)
  static String formatBubbleLabel(DateTime ts) {
    final now = DateTime.now();
    if (_isSameDay(ts, now)) return formatTime(ts);
    if (isWithinLastDays(ts, 7)) {
      return '${weekdayShort(ts)} ${formatTime(ts)}';
    }
    // Older: date + time
    return '${formatDate(ts)} ${formatTime(ts)}';
  }
}
