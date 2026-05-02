import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';
import 'theme_extension.dart';

abstract final class AppTheme {
  static const double radiusLg = 20;
  static const double radiusMd = 14;
  static const double radiusSm = 10;

  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: Palette.darkAccent,
      onPrimary: Palette.darkBg,
      surface: Palette.darkSurface,
      onSurface: Palette.darkText,
      onSurfaceVariant: Palette.darkMuted,
      outline: Palette.darkBorder,
      outlineVariant: Palette.darkBorderStrong,
    ).copyWith(
      surfaceContainerLowest: Palette.darkBg,
      surfaceContainerLow: Palette.darkSurface2,
      surfaceContainer: Palette.darkSurface2,
      surfaceContainerHigh: Palette.darkSurfacePress,
    );

    return _base(scheme, AppThemeColors.darkResolved());
  }

  static ThemeData light() {
    final scheme = ColorScheme.light(
      primary: Palette.lightAccent,
      onPrimary: Palette.lightBg,
      surface: Palette.lightSurface,
      onSurface: Palette.lightText,
      onSurfaceVariant: Palette.lightMuted,
      outline: Palette.lightBorder,
      outlineVariant: Palette.lightBorderStrong,
    ).copyWith(
      surfaceContainerLowest: Palette.lightBg,
      surfaceContainerLow: Palette.lightSurface2,
      surfaceContainer: Palette.lightSurface2,
      surfaceContainerHigh: Palette.lightSurfacePress,
    );

    return _base(scheme, AppThemeColors.lightResolved());
  }

  static ThemeData _base(ColorScheme scheme, AppThemeColors extra) {
    final brightness = scheme.brightness;
    final baseText = ThemeData(brightness: brightness, useMaterial3: true).textTheme;
    final textTheme = GoogleFonts.dmSansTextTheme(baseText);
    final primaryTextTheme = GoogleFonts.dmSansTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      extensions: [extra],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: extra.searchPlaceholder),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, space: 1, thickness: 1),
    );
  }
}
