import 'package:flutter/material.dart';

/// All color constants for the Strange app (Claymorphism + Swiss Red)
class AppColors {
  AppColors._();

  // --- Surface Colors ---
  static const Color surfaceBase = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF8F8F8);
  static const Color surfaceMuted = Color(0xFFF2F2F2);

  // --- Brand / Primary ---
  static const Color primary = Color(0xFFD52B1E); // Swiss flag red
  static const Color primaryDark = Color(0xFFB01F14); // pressed / active
  static const Color primaryLight = Color(0xFFE85A50); // highlights
  static const Color primaryContainer = Color(0xFFFFDBD9); // soft red chip bg
  static const Color onPrimary = Color(0xFFFFFFFF); // text/icon on red

  // --- Semantic & Accent ---
  static const Color goldAccent = Color(0xFFF5A623); // Deep Work indicator
  static const Color success = Color(0xFF34C759); // session completed
  static const Color warning = Color(0xFFFF9500); // pause warning
  static const Color error = Color(0xFFFF3B30); // delete confirmation

  // --- Text ---
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6C6C70);
  static const Color textOnSurface = Color(0xFF3A3A3C);

  // --- Clay Shadows ---
  static const Color clayShadowPrimary = Color(0x40D52B1E); // rgba 25% opacity
  static const Color clayShadowNeutral = Color(0x1A000000); // rgba 10% opacity
  static const Color clayHighlight = Color(0xCCFFFFFF); // rgba 80% white

  // --- Dark Mode Overrides ---
  static const Color darkSurfaceBase = Color(0xFF1C1C1E);
  static const Color darkSurfaceElevated = Color(0xFF2C2C2E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkClayShadowPrimary = Color(0x66D52B1E); // 40% opacity

  // --- Card Color Presets ---
  static const List<Color> cardPresets = [
    // Row 1 — Reds/Warm
    Color(0xFFD52B1E),
    Color(0xFFFF6B6B),
    Color(0xFFFF9F43),
    Color(0xFFFECA57),
    // Row 2 — Greens/Cool
    Color(0xFF48DBFB),
    Color(0xFF1DD1A1),
    Color(0xFF54A0FF),
    Color(0xFF5F27CD),
    // Row 3 — Neutrals
    Color(0xFF576574),
    Color(0xFF8395A7),
    Color(0xFFC8D6E5),
    Color(0xFFF1F2F6),
  ];

  // --- Chart Colors ---
  static const Color chartLearning = Color(0xFF54A0FF);
  static const Color chartProject = Color(0xFFF5A623);
  static const Color chartHabit = Color(0xFF1DD1A1);

  // --- Heatmap Levels ---
  static const Color heatmapLevel0 = Color(0xFFC8C8C8); // no session
  static const Color heatmapLevel1 = Color(0xFFFFDBD9); // < 15 min
  static const Color heatmapLevel2 = Color(0xFFFBAEA9); // < 30 min
  static const Color heatmapLevel3 = Color(0xFFF07470); // < 1 h
  static const Color heatmapLevel4 = Color(0xFFD52B1E); // < 2 h
  static const Color heatmapLevel5 = Color(0xFF8B1A13); // 2 h+
}
