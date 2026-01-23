import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatNoteDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDay = DateTime(date.year, date.month, date.day);

    if (noteDay == today) {
      return 'Today, ${DateFormat.jm().format(date)}';
    }
    final yesterday = today.subtract(const Duration(days: 1));
    if (noteDay == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    }
    return DateFormat.yMMMd().format(date);
  }

  static String formatFull(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }
}
