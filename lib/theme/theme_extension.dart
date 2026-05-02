import 'package:flutter/material.dart';

import 'palette.dart';

/// Tokens that do not map cleanly to [ColorScheme] (gradients, translucent fills).
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.accentDim,
    required this.detailBody,
    required this.searchPlaceholder,
    required this.overlayScrim,
    required this.thumbShadow,
    required this.thumbGradA,
    required this.thumbGradB,
    required this.posterGradA,
    required this.posterGradB,
    required this.footerNote,
  });

  final Color accentDim;
  final Color detailBody;
  final Color searchPlaceholder;
  final Color overlayScrim;
  final Color thumbShadow;
  final Color thumbGradA;
  final Color thumbGradB;
  final Color posterGradA;
  final Color posterGradB;
  final Color footerNote;

  factory AppThemeColors.darkResolved() {
    return AppThemeColors(
      accentDim: Palette.darkAccentDim(),
      detailBody: Palette.darkDetailBody,
      searchPlaceholder: Palette.darkSearchPlaceholder,
      overlayScrim: Palette.darkOverlayScrim(),
      thumbShadow: Palette.darkThumbShadow(),
      thumbGradA: Palette.darkThumbGradA,
      thumbGradB: Palette.darkThumbGradB,
      posterGradA: Palette.darkPosterGradA,
      posterGradB: Palette.darkPosterGradB,
      footerNote: Palette.darkFooterNote,
    );
  }

  factory AppThemeColors.lightResolved() {
    return AppThemeColors(
      accentDim: Palette.lightAccentDim(),
      detailBody: Palette.lightDetailBody,
      searchPlaceholder: Palette.lightSearchPlaceholder,
      overlayScrim: Palette.lightOverlayScrim(),
      thumbShadow: Palette.lightThumbShadow(),
      thumbGradA: Palette.lightThumbGradA,
      thumbGradB: Palette.lightThumbGradB,
      posterGradA: Palette.lightPosterGradA,
      posterGradB: Palette.lightPosterGradB,
      footerNote: Palette.lightFooterNote,
    );
  }

  @override
  AppThemeColors copyWith({
    Color? accentDim,
    Color? detailBody,
    Color? searchPlaceholder,
    Color? overlayScrim,
    Color? thumbShadow,
    Color? thumbGradA,
    Color? thumbGradB,
    Color? posterGradA,
    Color? posterGradB,
    Color? footerNote,
  }) {
    return AppThemeColors(
      accentDim: accentDim ?? this.accentDim,
      detailBody: detailBody ?? this.detailBody,
      searchPlaceholder: searchPlaceholder ?? this.searchPlaceholder,
      overlayScrim: overlayScrim ?? this.overlayScrim,
      thumbShadow: thumbShadow ?? this.thumbShadow,
      thumbGradA: thumbGradA ?? this.thumbGradA,
      thumbGradB: thumbGradB ?? this.thumbGradB,
      posterGradA: posterGradA ?? this.posterGradA,
      posterGradB: posterGradB ?? this.posterGradB,
      footerNote: footerNote ?? this.footerNote,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      detailBody: Color.lerp(detailBody, other.detailBody, t)!,
      searchPlaceholder:
          Color.lerp(searchPlaceholder, other.searchPlaceholder, t)!,
      overlayScrim: Color.lerp(overlayScrim, other.overlayScrim, t)!,
      thumbShadow: Color.lerp(thumbShadow, other.thumbShadow, t)!,
      thumbGradA: Color.lerp(thumbGradA, other.thumbGradA, t)!,
      thumbGradB: Color.lerp(thumbGradB, other.thumbGradB, t)!,
      posterGradA: Color.lerp(posterGradA, other.posterGradA, t)!,
      posterGradB: Color.lerp(posterGradB, other.posterGradB, t)!,
      footerNote: Color.lerp(footerNote, other.footerNote, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appThemeColors =>
      Theme.of(this).extension<AppThemeColors>()!;
}
