import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// TextStyle definitions for the Strange app
class AppTextStyles {
  AppTextStyles._();

  // --- App Title: "Strange" (Pacifico script) ---
  static TextStyle get appTitle => GoogleFonts.pacifico(
    fontSize: 28,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  // --- Timer Display (Roboto Mono, large) ---
  static TextStyle get timerDisplay => GoogleFonts.robotoMono(
    fontSize: 56,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static TextStyle get timerDisplaySmall => GoogleFonts.robotoMono(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // --- Card Name ---
  static TextStyle get cardName => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  // --- Body ---
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnSurface,
  );

  static TextStyle get bodyBold => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnSurface,
  );

  // --- Caption ---
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // --- Button ---
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.5,
  );

  // --- Phase Label (timer phase indicator) ---
  static TextStyle get phaseLabel => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 2.0,
  );

  // --- Heading ---
  static TextStyle get heading => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get subheading => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // --- Section Header ---
  static TextStyle get sectionHeader => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );
}
