import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_dimensions.dart';

/// BoxDecoration factories for the Claymorphism design system.
class ClayStyles {
  ClayStyles._();

  /// Raised clay surface (default card state) — light mode
  static BoxDecoration raised({
    Color? color,
    double radius = AppDimensions.radiusCard,
    bool isDark = false,
  }) {
    final surfaceColor =
        color ??
        (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated);
    return BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.darkClayShadowPrimary
              : AppColors.clayShadowPrimary,
          offset: const Offset(
            AppDimensions.shadowOffsetX1,
            AppDimensions.shadowOffsetY1,
          ),
          blurRadius: AppDimensions.shadowBlur1,
        ),
        const BoxShadow(
          color: AppColors.clayShadowNeutral,
          offset: Offset(
            AppDimensions.shadowOffsetX2,
            AppDimensions.shadowOffsetY2,
          ),
          blurRadius: AppDimensions.shadowBlur2,
        ),
      ],
    );
  }

  /// Pressed clay surface (tap/active state)
  static BoxDecoration pressed({
    Color? color,
    double radius = AppDimensions.radiusCard,
    bool isDark = false,
  }) {
    final surfaceColor =
        color ??
        (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated);
    return BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? AppColors.darkClayShadowPrimary
              : AppColors.clayShadowPrimary,
          offset: const Offset(
            AppDimensions.pressedShadowOffsetX1,
            AppDimensions.pressedShadowOffsetY1,
          ),
          blurRadius: AppDimensions.pressedShadowBlur1,
        ),
        const BoxShadow(
          color: AppColors.clayShadowNeutral,
          offset: Offset(
            AppDimensions.pressedShadowOffsetX2,
            AppDimensions.pressedShadowOffsetY2,
          ),
          blurRadius: AppDimensions.pressedShadowBlur2,
        ),
      ],
    );
  }

  /// Primary (red) clay surface — for active tabs, FAB, etc.
  static BoxDecoration primary({
    double radius = AppDimensions.radiusButton,
    bool isPressed = false,
  }) {
    return BoxDecoration(
      color: isPressed ? AppColors.primaryDark : AppColors.primary,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.clayShadowPrimary,
          offset: Offset(
            isPressed
                ? AppDimensions.pressedShadowOffsetX1
                : AppDimensions.shadowOffsetX1,
            isPressed
                ? AppDimensions.pressedShadowOffsetY1
                : AppDimensions.shadowOffsetY1,
          ),
          blurRadius: isPressed
              ? AppDimensions.pressedShadowBlur1
              : AppDimensions.shadowBlur1,
        ),
        BoxShadow(
          color: AppColors.clayShadowNeutral,
          offset: Offset(
            isPressed
                ? AppDimensions.pressedShadowOffsetX2
                : AppDimensions.shadowOffsetX2,
            isPressed
                ? AppDimensions.pressedShadowOffsetY2
                : AppDimensions.shadowOffsetY2,
          ),
          blurRadius: isPressed
              ? AppDimensions.pressedShadowBlur2
              : AppDimensions.shadowBlur2,
        ),
      ],
    );
  }

  /// Colored clay card surface (for StrangeCardWidget)
  static BoxDecoration coloredCard({
    required Color cardColor,
    double radius = AppDimensions.radiusCard,
    bool isPressed = false,
    bool isDark = false,
  }) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: cardColor.withValues(alpha: isDark ? 0.40 : 0.35),
          offset: Offset(
            isPressed
                ? AppDimensions.pressedShadowOffsetX1
                : AppDimensions.shadowOffsetX1,
            isPressed
                ? AppDimensions.pressedShadowOffsetY1
                : AppDimensions.shadowOffsetY1,
          ),
          blurRadius: isPressed
              ? AppDimensions.pressedShadowBlur1
              : AppDimensions.shadowBlur1,
        ),
        BoxShadow(
          color: AppColors.clayShadowNeutral,
          offset: Offset(
            isPressed
                ? AppDimensions.pressedShadowOffsetX2
                : AppDimensions.shadowOffsetX2,
            isPressed
                ? AppDimensions.pressedShadowOffsetY2
                : AppDimensions.shadowOffsetY2,
          ),
          blurRadius: isPressed
              ? AppDimensions.pressedShadowBlur2
              : AppDimensions.shadowBlur2,
        ),
      ],
    );
  }
}
