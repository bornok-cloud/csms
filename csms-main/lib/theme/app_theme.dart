import 'package:flutter/material.dart';

/// Central café-inspired color palette & theme used across the whole app.
class AppColors {
  static const cream = Color(0xFFFBF6EF);
  static const beige = Color(0xFFF3E7D8);
  static const beigeDark = Color(0xFFE8D7C0);
  static const darkBrown = Color(0xFF3E2723);
  static const brown = Color(0xFF6F4E37);
  static const brownDeep = Color(0xFF5A3A26);
  static const lightBrown = Color(0xFFB08968);
  static const accent = Color(0xFFD98324);
  static const accentDark = Color(0xFFB86A16);
  static const success = Color(0xFF2F9E62);
  static const warning = Color(0xFFE0A31B);
  static const danger = Color(0xFFD64545);
  static const info = Color(0xFF3F72AF);
  static const cardWhite = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFF8A7B6C);
  static const border = Color(0x22B08968);
}

/// Reusable elevation-style shadows so cards/panels feel consistent.
class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.darkBrown.withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];
  static List<BoxShadow> lifted = [
    BoxShadow(
      color: AppColors.darkBrown.withValues(alpha: 0.10),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];
}

class AppTheme {
  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brown,
      primary: AppColors.brown,
      secondary: AppColors.accent,
      surface: AppColors.cardWhite,
      error: AppColors.danger,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      splashFactory: InkSparkle.splashFactory,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,

      // ---- App bar ----
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        shadowColor: Color(0x14000000),
        titleTextStyle: TextStyle(
          color: AppColors.darkBrown,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: AppColors.darkBrown),
      ),

      // ---- Cards / surfaces ----
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          color: AppColors.darkBrown,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        contentTextStyle: const TextStyle(color: AppColors.darkBrown, fontSize: 14, height: 1.4),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cardWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
      ),

      // ---- Buttons ----
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.brown.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? Colors.white.withValues(alpha: 0.12)
                : states.contains(WidgetState.hovered)
                    ? Colors.white.withValues(alpha: 0.06)
                    : null,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brown,
          side: const BorderSide(color: AppColors.brown, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brown,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.darkBrown,
          highlightColor: AppColors.beige,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.cardWhite,
          foregroundColor: AppColors.darkBrown,
          selectedBackgroundColor: AppColors.brown,
          selectedForegroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      ),

      // ---- Navigation ----
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.cardWhite,
        indicatorColor: AppColors.accent.withValues(alpha: 0.16),
        elevation: 3,
        surfaceTintColor: Colors.transparent,
        height: 66,
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? AppColors.accentDark : AppColors.textMuted,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? AppColors.darkBrown : AppColors.textMuted,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            fontSize: 11.5,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.darkBrown,
        indicatorColor: AppColors.accent.withValues(alpha: 0.18),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        selectedIconTheme: const IconThemeData(color: AppColors.accent),
        unselectedIconTheme: const IconThemeData(color: Colors.white70),
        selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.darkBrown,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: AppColors.accent,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.border,
      ),

      // ---- Inputs ----
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        labelStyle: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7)),
        floatingLabelStyle: const TextStyle(color: AppColors.brown, fontWeight: FontWeight.w700),
        prefixIconColor: AppColors.lightBrown,
        suffixIconColor: AppColors.lightBrown,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.lightBrown.withValues(alpha: 0.35)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.lightBrown.withValues(alpha: 0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brown, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.8),
        ),
        errorStyle: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w500, fontSize: 12),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.brown : Colors.transparent,
        ),
        side: const BorderSide(color: AppColors.lightBrown, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.brown : AppColors.lightBrown,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? AppColors.brown : AppColors.beigeDark,
        ),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.brown,
        thumbColor: AppColors.brown,
        inactiveTrackColor: AppColors.beigeDark,
      ),

      // ---- Chips ----
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.beige,
        selectedColor: AppColors.brown,
        disabledColor: AppColors.beige.withValues(alpha: 0.5),
        labelStyle: const TextStyle(color: AppColors.darkBrown, fontWeight: FontWeight.w600, fontSize: 12.5),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.5),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),

      // ---- Lists / misc ----
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: AppColors.brown,
        textColor: AppColors.darkBrown,
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.lightBrown.withValues(alpha: 0.18),
        space: 1,
        thickness: 1,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.darkBrown.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.cardWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkBrown,
        contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        actionTextColor: AppColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.beige,
        circularTrackColor: AppColors.beige,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: const WidgetStatePropertyAll(AppColors.beige),
        headingTextStyle: const TextStyle(
          color: AppColors.darkBrown,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
        dataTextStyle: const TextStyle(color: AppColors.darkBrown, fontSize: 13.5),
        dividerThickness: 0.6,
      ),

      // ---- Type scale ----
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w800, color: AppColors.darkBrown, letterSpacing: -0.5),
        headlineLarge: TextStyle(fontWeight: FontWeight.w800, color: AppColors.darkBrown, letterSpacing: -0.3),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkBrown, letterSpacing: -0.2),
        headlineSmall: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkBrown),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkBrown),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkBrown),
        titleSmall: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkBrown),
        bodyLarge: TextStyle(color: AppColors.darkBrown, height: 1.45),
        bodyMedium: TextStyle(color: AppColors.darkBrown, height: 1.4),
        bodySmall: TextStyle(color: AppColors.textMuted, height: 1.3),
        labelLarge: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkBrown),
      ),
      dividerColor: AppColors.lightBrown.withValues(alpha: 0.25),
    );
  }
}

String peso(num amount) => '₱${amount.toStringAsFixed(2)}';
