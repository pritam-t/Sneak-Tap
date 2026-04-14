import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme get textTheme {
    return GoogleFonts.libreBaskervilleTextTheme().copyWith(
      displayLarge: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.libreBaskerville(
        color: AppColors.secondary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: GoogleFonts.libreBaskerville(
        color: AppColors.primary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
