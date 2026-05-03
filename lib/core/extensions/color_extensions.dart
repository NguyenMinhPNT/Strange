import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Convert color to hex string like '#D52B1E'
  String toHex({bool includeHash = true}) {
    final r = ((this.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final g = ((this.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final b = ((this.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    return '${includeHash ? '#' : ''}$r$g$b'.toUpperCase();
  }

  /// Lighten the color by [amount] (0.0–1.0)
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken the color by [amount] (0.0–1.0)
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Clay shadow color with given opacity
  Color withClayOpacity(double opacity) => withValues(alpha: opacity);
}

extension StringColorExtensions on String {
  /// Parse '#RRGGBB' or 'RRGGBB' to a Color
  Color toColor() {
    final hex = replaceAll('#', '');
    final value = int.tryParse('FF$hex', radix: 16) ?? 0xFFD52B1E;
    return Color(value);
  }
}
