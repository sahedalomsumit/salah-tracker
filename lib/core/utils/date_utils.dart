import 'package:intl/intl.dart';

class SalahDateUtils {
  SalahDateUtils._();

  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static final _displayFormat = DateFormat('EEEE, d MMMM yyyy');
  static final _shortFormat = DateFormat('EEE, d MMM');
  static final _monthFormat = DateFormat('MMMM yyyy');

  /// Convert DateTime → storage key (yyyy-MM-dd)
  static String toKey(DateTime date) => _dateFormat.format(date);

  /// Today's key
  static String todayKey() => toKey(DateTime.now());

  /// Parse storage key back to DateTime
  static DateTime fromKey(String key) => _dateFormat.parse(key);

  /// Human-readable full date
  static String displayDate(DateTime date) => _displayFormat.format(date);

  /// Human-readable short date
  static String shortDate(DateTime date) => _shortFormat.format(date);

  /// Month label
  static String monthLabel(DateTime date) => _monthFormat.format(date);

  /// Whether two DateTimes are on the same calendar day
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Whether a date key is today
  static bool isToday(String key) => key == todayKey();

  /// Get a list of [days] dates ending today (inclusive), oldest first
  static List<DateTime> lastNDays(int days) {
    final today = DateTime.now();
    return List.generate(
      days,
      (i) => today.subtract(Duration(days: days - 1 - i)),
    );
  }

  /// Get dates of the current calendar week (Mon–Sun)
  static List<DateTime> currentWeek() {
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  /// Get dates of the current calendar month
  static List<DateTime> currentMonth() {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, 1);
    final last = DateTime(now.year, now.month + 1, 0);
    final count = last.day;
    return List.generate(count, (i) => first.add(Duration(days: i)));
  }

  /// Day-of-week abbreviations
  static String dayAbbr(DateTime date) => DateFormat('EEE').format(date);
}
