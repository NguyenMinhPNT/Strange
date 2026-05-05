import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = [
      (AppColors.heatmapLevel0, 'None'),
      (AppColors.heatmapLevel1, '<15m'),
      (AppColors.heatmapLevel2, '<30m'),
      (AppColors.heatmapLevel3, '<1h'),
      (AppColors.heatmapLevel4, '<2h'),
      (AppColors.heatmapLevel5, '2h+'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Less',
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        ...levels.map(
          (l) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Tooltip(
              message: l.$2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: l.$1,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'More',
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
