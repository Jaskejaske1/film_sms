import 'belgian_formatter.dart';

class DateFormatter {
  static String ddMMyyyy(DateTime date) => BelgianFormatter.formatDate(date);
  static String hhUmm(DateTime time) => BelgianFormatter.formatTime(time);
}
