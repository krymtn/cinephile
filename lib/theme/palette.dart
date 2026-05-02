import 'package:flutter/material.dart';

/// Design tokens from the movies-screen-mock `index.html` palettes.
abstract final class Palette {
  // Dark (default .app-root)
  static const Color darkBg = Color(0xFF0C0C0E);
  static const Color darkSurface = Color(0xFF141417);
  static const Color darkSurface2 = Color(0xFF1A1A1F);
  static const Color darkSurfacePress = Color(0xFF222228);
  static const Color darkBorder = Color(0xFF2A2A32);
  static const Color darkBorderStrong = Color(0xFF3A3A44);
  static const Color darkText = Color(0xFFF4F4F5);
  static const Color darkMuted = Color(0xFF8B8B96);
  static const Color darkAccent = Color(0xFFC9A227);
  static const Color darkDetailBody = Color(0xFFC4C4CC);
  static const Color darkSearchPlaceholder = Color(0xFF5C5C66);
  static const Color darkFooterNote = Color(0xFF5C5C66);
  static const Color darkThumbGradA = Color(0xFF2A2A32);
  static const Color darkThumbGradB = Color(0xFF1A1A22);
  static const Color darkPosterGradA = Color(0xFF353542);
  static const Color darkPosterGradB = Color(0xFF1E1E26);

  // Light (.app-root.theme-light)
  static const Color lightBg = Color(0xFFF4F4F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF4F4F6);
  static const Color lightSurfacePress = Color(0xFFECECF2);
  static const Color lightBorder = Color(0xFFE4E4EC);
  static const Color lightBorderStrong = Color(0xFFD4D4DE);
  static const Color lightText = Color(0xFF18181B);
  static const Color lightMuted = Color(0xFF71717B);
  static const Color lightAccent = Color(0xFFA16207);
  static const Color lightDetailBody = Color(0xFF3F3F4A);
  static const Color lightSearchPlaceholder = Color(0xFF9C9CAA);
  static const Color lightFooterNote = Color(0xFF71717B);
  static const Color lightThumbGradA = Color(0xFFD4D4DE);
  static const Color lightThumbGradB = Color(0xFFEBEBF2);
  static const Color lightPosterGradA = Color(0xFFDCDCE6);
  static const Color lightPosterGradB = Color(0xFFC8C8D4);

  static Color darkAccentDim() => darkAccent.withValues(alpha: 0.18);

  static Color lightAccentDim() => lightAccent.withValues(alpha: 0.12);

  static Color darkOverlayScrim() => Colors.black.withValues(alpha: 0.5);

  static Color lightOverlayScrim() =>
      const Color(0xFF18181D).withValues(alpha: 0.35);

  static Color darkThumbShadow() => Colors.black.withValues(alpha: 0.45);

  static Color lightThumbShadow() =>
      const Color(0xFF18181D).withValues(alpha: 0.2);
}
