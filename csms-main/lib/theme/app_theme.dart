import 'package:flutter/material.dart';

/// Central café-inspired color palette & theme used across the whole app.
class AppColors {
  static const cream = Color(0xFFFBF6EF);
  static const beige = Color(0xFFF3E7D8);
  static const darkBrown = Color(0xFF3E2723);
  static const brown = Color(0xFF6F4E37);
  static const lightBrown = Color(0xFFB08968);
  static const accent = Color(0xFFD98324);
  static const success = Color(0xFF3E8E5A);
  static const warning = Color(0xFFE0A31B);
  static const danger = Color(0xFFC0392B);
  static const info = Color(0xFF3F72AF);
  static const cardWhite = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFF8A7B6C);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brown,
        primary: AppColors.brown,
        secondary: AppColors.accent,
        surface: AppColors.cardWhite,
        brightness: Brightness.light,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardWhite,
        indicatorColor: AppColors.beige,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.darkBrown,
        indicatorColor: AppColors.accent.withValues(alpha: 0.18),
        selectedIconTheme: const IconThemeData(color: AppColors.accent),
        unselectedIconTheme: const IconThemeData(color: Colors.white70),
        selectedLabelTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.lightBrown.withValues(alpha: 0.18),
        space: 1,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brown,
          side: const BorderSide(color: AppColors.brown),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.lightBrown.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.lightBrown.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brown, width: 1.6),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium:
            TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown),
        titleLarge:
            TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown),
        titleMedium:
            TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkBrown),
        bodyMedium: TextStyle(color: AppColors.darkBrown),
      ),
      dividerColor: AppColors.lightBrown.withValues(alpha: 0.25),
    );
  }
}

String peso(num amount) => '₱${amount.toStringAsFixed(2)}';
