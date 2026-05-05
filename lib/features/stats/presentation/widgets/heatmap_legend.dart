import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    const levels = <Color>[
      Color(0xFFF6E7E5),
      Color(0xFFF3CCC7),
      Color(0xFFF1BBB5),
      Color(0xFFF09C96),
      Color(0xFFEB6D66),
      Color(0xFFE03A33),
      Color(0xFFD52B1E),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Less',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        ...levels.map(
          (color) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'More',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
