import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';
import 'app_typography.dart';
import 'dark_palette.dart';
import 'light_palette.dart';

/// Builds the premium light and dark ThemeData for Solar Panel Care.
/// Developed by Panel Care Team 7-H.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(const LightPalette());

  static ThemeData dark() => _build(const DarkPalette());

  static ThemeData _build(AppPalette p) {
    final bool isDark = p.brightness == Brightness.dark;
    final ColorScheme scheme = ColorScheme(
      brightness: p.brightness,
      primary: AppColors.sunAmber,
      onPrimary: isDark ? const Color(0xFF171510) : Colors.white,
      secondary: AppColors.deepOrange,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: p.surface,
      onSurface: p.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      textTheme: AppTypography.build(p.textPrimary, p.textSecondary),
      dividerColor: p.cardBorder,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: p.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: p.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: p.cardBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(color: p.cardBorder, thickness: 1),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.sunOrange
              : p.surfaceAlt,
        ),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : p.textFaint,
        ),
        overlayColor: WidgetStateProperty.all(
          AppColors.sunAmber.withOpacity(0.15),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.sunOrange,
        inactiveTrackColor: p.surfaceAlt,
        thumbColor: AppColors.sunAmber,
        overlayColor: AppColors.sunAmber.withOpacity(0.15),
        valueIndicatorColor: AppColors.charcoal,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceAlt,
        side: BorderSide(color: p.cardBorder),
        labelStyle: TextStyle(color: p.textSecondary, fontSize: 12.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: AppColors.sunAmber.withOpacity(0.20),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11.5,
            fontWeight:
                states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? p.textPrimary
                : p.textFaint,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.sunOrange
                : p.textFaint,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: p.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.sunOrange, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: TextStyle(color: p.textFaint, fontSize: 14),
        labelStyle: TextStyle(color: p.textSecondary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sunOrange,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 54),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deepOrange,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      iconTheme: IconThemeData(color: p.textPrimary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.sunOrange,
        linearTrackColor: AppColors.creamDeep,
      ),
    );
  }
}
