import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/column_data.dart';

class ColumnChartWidget extends StatelessWidget {
  const ColumnChartWidget({super.key, required this.data});

  final List<ColumnData> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No data for this period',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final maxSeconds = data
        .map((d) => d.totalSeconds)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final maxHours =
        (maxSeconds / 3600).ceilToDouble().clamp(1.0, double.infinity);

    final groups = data.asMap().entries.map((entry) {
      final i = entry.key;
      final d = entry.value;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: d.totalSeconds / 3600,
            width: _barWidth(data.length),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            rodStackItems: [
              BarChartRodStackItem(
                0,
                d.learningSeconds / 3600,
                AppColors.chartLearning,
              ),
              BarChartRodStackItem(
                d.learningSeconds / 3600,
                (d.learningSeconds + d.projectSeconds) / 3600,
                AppColors.chartProject,
              ),
              BarChartRodStackItem(
                (d.learningSeconds + d.projectSeconds) / 3600,
                d.totalSeconds / 3600,
                AppColors.chartHabit,
              ),
            ],
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxHours,
          barGroups: groups,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval:
                maxHours > 2 ? (maxHours / 4).ceilToDouble() : 0.5,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: AppColors.surfaceMuted,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: maxHours > 2 ? (maxHours / 4).ceilToDouble() : 0.5,
                getTitlesWidget: (value, _) => Text(
                  '${value.toInt()}h',
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox.shrink();
                  final d = data[i].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _shortLabel(d, data.length),
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, __) {
                final d = data[group.x];
                final h = (d.totalSeconds / 3600).toStringAsFixed(1);
                return BarTooltipItem(
                  '${d.date.day}/${d.date.month}\n${h}h',
                  const TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _barWidth(int count) {
    if (count <= 7) return 18;
    if (count <= 31) return 8;
    return 4;
  }

  String _shortLabel(DateTime d, int totalCount) {
    if (totalCount <= 7) return '${d.day}/${d.month}';
    if (totalCount <= 31) return '${d.day}';
    // Monthly: show month abbrev on 1st of month
    if (d.day == 1) {
      const months = [
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
      return months[d.month];
    }
    return '';
  }
}
