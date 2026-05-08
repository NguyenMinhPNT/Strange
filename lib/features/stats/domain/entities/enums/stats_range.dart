enum StatsRange {
  oneMonth,
  threeMonths,
  oneYear;

  String get label {
    switch (this) {
      case StatsRange.oneMonth:
        return '1M';
      case StatsRange.threeMonths:
        return '3M';
      case StatsRange.oneYear:
        return '1Y';
    }
  }

  DateTime get startDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (this) {
      case StatsRange.oneMonth:
        return DateTime(today.year, today.month - 1, today.day);
      case StatsRange.threeMonths:
        return DateTime(today.year, today.month - 3, today.day);
      case StatsRange.oneYear:
        return DateTime(today.year - 1, today.month, today.day);
    }
  }
}
