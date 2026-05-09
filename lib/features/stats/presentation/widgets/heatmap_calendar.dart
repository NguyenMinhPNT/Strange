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
    required this.visibleStart,
    required this.visibleEnd,
  });

  final List<DayStat> data;
  final StatsRange range;
  final DateTime visibleStart;
  final DateTime visibleEnd;

  @override
  State<HeatmapCalendar> createState() => _HeatmapCalendarState();
}

class _HeatmapCalendarState extends State<HeatmapCalendar> {
  static const double _scale = 1.35;

  DateTime? _tappedDay;
  late final ScrollController _scrollController;
  late Map<String, int> _statsByDay;
  late List<List<DateTime?>> _weeks;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scheduleScrollToTodayIfNeeded();
  }

  @override
  void didUpdateWidget(covariant HeatmapCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.range != widget.range ||
        oldWidget.data != widget.data ||
        oldWidget.visibleStart != widget.visibleStart ||
        oldWidget.visibleEnd != widget.visibleEnd) {
      _scheduleScrollToTodayIfNeeded();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scheduleScrollToTodayIfNeeded() {
    if (widget.range != StatsRange.threeMonths &&
        widget.range != StatsRange.oneYear) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToToday();
    });
  }

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
    _statsByDay = {
      for (final s in widget.data) _dayKey(s.date): s.totalSeconds,
    };

    final start = DateTime(
      widget.visibleStart.year,
      widget.visibleStart.month,
      widget.visibleStart.day,
    );
    final end = DateTime(
      widget.visibleEnd.year,
      widget.visibleEnd.month,
      widget.visibleEnd.day,
    );
    final highlightedDay = _resolveHighlightedDay(start, end);
    final firstMonday = _startOfWeek(start);

    _weeks = <List<DateTime?>>[];
    var weekStart = firstMonday;
    while (!weekStart.isAfter(end)) {
      final week = <DateTime?>[];
      for (int i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        week.add(day.isBefore(start) || day.isAfter(end) ? null : day);
      }
      _weeks.add(week);
      weekStart = weekStart.add(const Duration(days: 7));
    }

    const dotSize = 15.0 * _scale;
    const rowGap = 9.0 * _scale;
    const columnGap = 9.0 * _scale;
    const dayLabelWidth = 44.0 * _scale;
    const cellWidth = dotSize + columnGap;
    const cellHeight = dotSize + rowGap;
    final chartWidth = dayLabelWidth + _weeks.length * cellWidth;
    const chartHeight = 7 * cellHeight;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: GestureDetector(
          onTapUp: (details) {
            final dx = details.localPosition.dx - dayLabelWidth;
            final dy = details.localPosition.dy;
            if (dx < 0 || dy < 0) return;
            final col = (dx / cellWidth).floor();
            final row = (dy / cellHeight).floor();
            if (col >= _weeks.length || row >= 7) return;
            final day = _weeks[col][row];
            if (day == null) return;
            final seconds = _statsByDay[_dayKey(day)] ?? 0;
            _onTap(day, seconds);
          },
          child: CustomPaint(
            size: Size(chartWidth, chartHeight),
            painter: _HeatmapPainter(
              weeks: _weeks,
              statsByDay: _statsByDay,
              highlightedDay: highlightedDay,
              scale: _scale,
            ),
          ),
        ),
      ),
    );
  }

  DateTime _startOfWeek(DateTime? date) {
    final current = date ?? DateTime.now();
    final weekday = current.weekday; // Mon=1, Sun=7
    return current.subtract(Duration(days: weekday - 1));
  }

  DateTime? _resolveHighlightedDay(DateTime start, DateTime end) {
    if (_tappedDay != null) {
      return _tappedDay;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inRange = !today.isBefore(start) && !today.isAfter(end);
    return inRange ? today : null;
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.weeks,
    required this.statsByDay,
    this.highlightedDay,
    required this.scale,
  });

  final List<List<DateTime?>> weeks;
  final Map<String, int> statsByDay;
  final DateTime? highlightedDay;
  final double scale;

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void paint(Canvas canvas, Size size) {
    final dotSize = 15.0 * scale;
    final rowGap = 9.0 * scale;
    final columnGap = 9.0 * scale;
    final dayLabelWidth = 44.0 * scale;
    final cellWidth = dotSize + columnGap;
    final cellHeight = dotSize + rowGap;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int row = 0; row < 7; row++) {
      textPainter.text = TextSpan(
        text: _dayLabels[row],
        style: TextStyle(
          fontSize: 13 * scale,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, row * cellHeight + (dotSize - textPainter.height) / 2),
      );
    }

    for (int col = 0; col < weeks.length; col++) {
      for (int row = 0; row < 7; row++) {
        final day = weeks[col][row];
        if (day == null) continue;

        final key = '${day.year}-${day.month}-${day.day}';
        final seconds = statsByDay[key] ?? 0;
        final color = _heatColor(seconds);
        final cx = dayLabelWidth + col * cellWidth + dotSize / 2;
        final cy = row * cellHeight + dotSize / 2;

        canvas.drawCircle(Offset(cx, cy), dotSize / 2, Paint()..color = color);

        final isHighlighted = highlightedDay != null &&
            day.year == highlightedDay!.year &&
            day.month == highlightedDay!.month &&
            day.day == highlightedDay!.day;
        if (isHighlighted) {
          canvas.drawCircle(
            Offset(cx, cy),
            dotSize / 2 + (1.5 * scale),
            Paint()
              ..color = AppColors.primaryDark
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5 * scale,
          );
        }
      }
    }
  }

  Color _heatColor(int seconds) {
    if (seconds == 0) return const Color(0xFFF6E7E5);
    if (seconds < AppConstants.heatmapLevel1Seconds) {
      return const Color(0xFFF3CCC7);
    }
    if (seconds < AppConstants.heatmapLevel2Seconds) {
      return const Color(0xFFF09C96);
    }
    if (seconds < AppConstants.heatmapLevel3Seconds) {
      return const Color(0xFFEB6D66);
    }
    if (seconds < AppConstants.heatmapLevel4Seconds) {
      return const Color(0xFFE03A33);
    }
    return const Color(0xFFD52B1E);
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.weeks != weeks ||
      old.statsByDay != statsByDay ||
      old.highlightedDay != highlightedDay;
}
