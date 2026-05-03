import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// A small colored circle indicator (card color dot).
class ColorDot extends StatelessWidget {
  const ColorDot({
    super.key,
    required this.color,
    this.size = 16.0,
    this.hasBorder = true,
  });

  final Color color;
  final double size;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(color: AppColors.clayShadowNeutral, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: AppDimensions.space4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
