import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';
import 'clay_styles.dart';

/// Extension on BuildContext for convenient clay theme access.
extension ClayThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get claySurface =>
      isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;

  Color get clayShadowColor =>
      isDark ? AppColors.darkClayShadowPrimary : AppColors.clayShadowPrimary;

  BoxDecoration clayRaised({
    Color? color,
    double radius = AppDimensions.radiusCard,
  }) => ClayStyles.raised(color: color, radius: radius, isDark: isDark);

  BoxDecoration clayPressed({
    Color? color,
    double radius = AppDimensions.radiusCard,
  }) => ClayStyles.pressed(color: color, radius: radius, isDark: isDark);

  BoxDecoration clayPrimary({
    double radius = AppDimensions.radiusButton,
    bool isPressed = false,
  }) => ClayStyles.primary(radius: radius, isPressed: isPressed);

  BoxDecoration clayColoredCard({
    required Color cardColor,
    double radius = AppDimensions.radiusCard,
    bool isPressed = false,
  }) => ClayStyles.coloredCard(
    cardColor: cardColor,
    radius: radius,
    isPressed: isPressed,
    isDark: isDark,
  );
}
