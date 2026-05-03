extension DateExtensions on DateTime {
  DateTime toDateOnly() => DateTime(year, month, day);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isToday() => isSameDay(DateTime.now());

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  /// Returns the start (Monday) and end (Sunday) of the week containing this date.
  (DateTime start, DateTime end) weekRange() {
    final weekday = this.weekday; // 1=Mon, 7=Sun
    final start = toDateOnly().subtract(Duration(days: weekday - 1));
    final end = start.add(const Duration(days: 6));
    return (start, end);
  }

  DateTime startOfDay() => DateTime(year, month, day);
  DateTime endOfDay() => DateTime(year, month, day, 23, 59, 59, 999);
}
