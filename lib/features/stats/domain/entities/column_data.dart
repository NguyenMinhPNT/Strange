class ColumnData {
  const ColumnData({
    required this.date,
    required this.learningSeconds,
    required this.projectSeconds,
    required this.habitSeconds,
  });

  final DateTime date;
  final int learningSeconds;
  final int projectSeconds;
  final int habitSeconds;

  int get totalSeconds => learningSeconds + projectSeconds + habitSeconds;
}
