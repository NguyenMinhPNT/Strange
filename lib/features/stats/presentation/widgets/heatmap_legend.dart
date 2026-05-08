import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});
  static const double _scale = 1.35;

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

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Less',
            style: TextStyle(
              fontSize: 14 * _scale,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12 * _scale),
          ...levels.map(
            (color) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5 * _scale),
              child: Container(
                width: 15 * _scale,
                height: 15 * _scale,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12 * _scale),
          const Text(
            'More',
            style: TextStyle(
              fontSize: 14 * _scale,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
