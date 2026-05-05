import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/pie_slice.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({
    super.key,
    required this.slices,
    required this.totalSeconds,
  });

  final List<PieSlice> slices;
  final int totalSeconds;

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.totalSeconds == 0) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No data for this period',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final totalHours = widget.totalSeconds / 3600;
    final totalLabel = totalHours >= 1
        ? '${totalHours.toStringAsFixed(1)}h'
        : '${(widget.totalSeconds ~/ 60)}m';

    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 48,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                centerSpaceColor: Colors.white,
                sections: widget.slices.asMap().entries.map((entry) {
                  final i = entry.key;
                  final slice = entry.value;
                  final isTouched = i == _touchedIndex;
                  final pct = widget.totalSeconds > 0
                      ? (slice.totalSeconds / widget.totalSeconds * 100)
                          .toStringAsFixed(0)
                      : '0';
                  return PieChartSectionData(
                    value: slice.totalSeconds.toDouble(),
                    color: slice.color,
                    radius: isTouched ? 58 : 48,
                    title: '$pct%',
                    titleStyle: TextStyle(
                      fontSize: isTouched ? 13 : 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.6,
                  );
                }).toList(),
              ),
            ),
          ),
          // Center label overlay — we draw it via a Stack
          const SizedBox(width: 16),
          _PieLegend(slices: widget.slices, totalLabel: totalLabel),
        ],
      ),
    );
  }
}

class _PieLegend extends StatelessWidget {
  const _PieLegend({
    required this.slices,
    required this.totalLabel,
  });

  final List<PieSlice> slices;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          totalLabel,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...slices.map(
          (s) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  s.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
