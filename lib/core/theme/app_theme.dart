import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Colors ──────────────────────────────────────────────────────────
  static const Color _primaryLight = Color(0xFF0A84FF);
  static const Color _primaryDark = Color(0xFF64D2FF);

  static const Color _bgLight = Color(0xFFF8F9FA);
  static const Color _bgDark = Color(0xFF0D1117);

  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _surfaceDark = Color(0xFF161B22);

  static const Color _textLight = Color(0xFF1A1A2E);
  static const Color _textDark = Color(0xFFE6EDF3);

  static const Color _subtextLight = Color(0xFF6B7280);
  static const Color _subtextDark = Color(0xFF8B949E);

  // ── Typography ──────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(
    TextTheme base,
    Color textColor,
    Color subtextColor,
  ) {
    return base.copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: textColor,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: subtextColor,
        height: 1.7,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: subtextColor,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: subtextColor,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  // ── Light Theme ─────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary: _primaryLight,
        surface: _surfaceLight,
        onSurface: _textLight,
      ),
      scaffoldBackgroundColor: _bgLight,
      textTheme: _buildTextTheme(base.textTheme, _textLight, _subtextLight),
      appBarTheme: AppBarTheme(
        backgroundColor: _bgLight.withAlpha(230),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _textLight,
        ),
        iconTheme: const IconThemeData(color: _textLight),
      ),
      cardTheme: CardThemeData(
        color: _surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: _primaryLight),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: _primaryDark,
        surface: _surfaceDark,
        onSurface: _textDark,
      ),
      scaffoldBackgroundColor: _bgDark,
      textTheme: _buildTextTheme(base.textTheme, _textDark, _subtextDark),
      appBarTheme: AppBarTheme(
        backgroundColor: _bgDark.withAlpha(230),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _textDark,
        ),
        iconTheme: const IconThemeData(color: _textDark),
      ),
      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withAlpha(25)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: _bgDark,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: _primaryDark),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
