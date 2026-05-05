import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/day_stat.dart';
import '../../domain/entities/enums/stats_range.dart';

class HeatmapCalendar extends StatefulWidget {
  const HeatmapCalendar({
    super.key,
    required this.data,
    required this.range,
  });

  final List<DayStat> data;
  final StatsRange range;

  @override
  State<HeatmapCalendar> createState() => _HeatmapCalendarState();
}

class _HeatmapCalendarState extends State<HeatmapCalendar> {
  DateTime? _tappedDay;

  void _onTap(DateTime day, int seconds) {
    setState(() => _tappedDay = day);
    if (!context.mounted) return;
    final minutes = seconds ~/ 60;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final label = h > 0 ? '${h}h ${m}m' : '${m}m';
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          '${day.day}/${day.month}/${day.year}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        content: Text(
          seconds == 0 ? 'No sessions recorded.' : 'Work time: $label',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsByDay = {
      for (final s in widget.data) _dayKey(s.date): s.totalSeconds,
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = widget.range.startDate;

    // Build list of all days in range
    final days = <DateTime>[];
    var d = start;
    while (!d.isAfter(today)) {
      days.add(d);
      d = d.add(const Duration(days: 1));
    }

    // Group into weeks (columns), starting on Monday
    final firstMonday = _startOfWeek(start);
    final weeks = <List<DateTime?>>[];
    var weekStart = firstMonday;
    while (!weekStart.isAfter(today)) {
      final week = <DateTime?>[];
      for (int i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        week.add(day.isBefore(start) || day.isAfter(today) ? null : day);
      }
      weeks.add(week);
      weekStart = weekStart.add(const Duration(days: 7));
    }

    const dotSize = 10.0;
    const dotSpacing = 3.0;
    const cell = dotSize + dotSpacing;
    const labelHeight = 18.0;
    const dayLabelWidth = 24.0;

    final chartWidth = weeks.length * cell + dayLabelWidth;
    const chartHeight = 7 * cell + labelHeight;

    return SizedBox(
      height: chartHeight,
      child: GestureDetector(
        onTapUp: (details) {
          final dx = details.localPosition.dx - dayLabelWidth;
          final dy = details.localPosition.dy - labelHeight;
          if (dx < 0 || dy < 0) return;
          final col = (dx / cell).floor();
          final row = (dy / cell).floor();
          if (col >= weeks.length || row >= 7) return;
          final day = weeks[col][row];
          if (day == null) return;
          final seconds = statsByDay[_dayKey(day)] ?? 0;
          _onTap(day, seconds);
        },
        child: CustomPaint(
          size: Size(chartWidth, chartHeight),
          painter: _HeatmapPainter(
            weeks: weeks,
            statsByDay: statsByDay,
            tappedDay: _tappedDay,
          ),
        ),
      ),
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final weekday = date.weekday; // Mon=1, Sun=7
    return date.subtract(Duration(days: weekday - 1));
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.weeks,
    required this.statsByDay,
    this.tappedDay,
  });

  final List<List<DateTime?>> weeks;
  final Map<String, int> statsByDay;
  final DateTime? tappedDay;

  static const dotSize = 10.0;
  static const dotSpacing = 3.0;
  static const cell = dotSize + dotSpacing;
  static const labelHeight = 18.0;
  static const dayLabelWidth = 24.0;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw day-of-week labels (Mon–Sun)
    for (int row = 0; row < 7; row++) {
      textPainter.text = TextSpan(
        text: _dayLabels[row],
        style: const TextStyle(
          fontSize: 9,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
            0, labelHeight + row * cell + (dotSize - textPainter.height) / 2),
      );
    }

    // Draw month labels & dots
    int? lastMonth;
    for (int col = 0; col < weeks.length; col++) {
      final week = weeks[col];
      final firstDay = week.firstWhere((d) => d != null, orElse: () => null);

      // Month label on first column of that month
      if (firstDay != null && firstDay.month != lastMonth) {
        lastMonth = firstDay.month;
        textPainter.text = TextSpan(
          text: _monthNames[firstDay.month],
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(dayLabelWidth + col * cell, 0),
        );
      }

      for (int row = 0; row < 7; row++) {
        final day = week[row];
        final cx = dayLabelWidth + col * cell + dotSize / 2;
        final cy = labelHeight + row * cell + dotSize / 2;

        Color color;
        if (day == null) {
          color = Colors.transparent;
        } else {
          final key = '${day.year}-${day.month}-${day.day}';
          final seconds = statsByDay[key] ?? 0;
          color = _heatColor(seconds);
        }

        final paint = Paint()..color = color;

        final isTapped = day != null &&
            tappedDay != null &&
            day.year == tappedDay!.year &&
            day.month == tappedDay!.month &&
            day.day == tappedDay!.day;

        if (color != Colors.transparent) {
          canvas.drawCircle(Offset(cx, cy), dotSize / 2, paint);
          if (isTapped) {
            canvas.drawCircle(
              Offset(cx, cy),
              dotSize / 2 + 1.5,
              Paint()
                ..color = AppColors.textPrimary
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5,
            );
          }
        }
      }
    }
  }

  Color _heatColor(int seconds) {
    if (seconds == 0) return AppColors.heatmapLevel0;
    if (seconds < AppConstants.heatmapLevel1Seconds)
      return AppColors.heatmapLevel1;
    if (seconds < AppConstants.heatmapLevel2Seconds)
      return AppColors.heatmapLevel2;
    if (seconds < AppConstants.heatmapLevel3Seconds)
      return AppColors.heatmapLevel3;
    if (seconds < AppConstants.heatmapLevel4Seconds)
      return AppColors.heatmapLevel4;
    return AppColors.heatmapLevel5;
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.weeks != weeks ||
      old.statsByDay != statsByDay ||
      old.tappedDay != tappedDay;
}
