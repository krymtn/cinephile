import 'package:flutter/foundation.dart';

import 'media_tile_display.dart';

/// Flat, domain-free data for a media list row (thumb + title + subtitle + score).
///
/// Feature mappers build this from [Movie] / [TvSeries]; [MediaRowCell] renders it.
@immutable
class MediaRowDisplay {
  const MediaRowDisplay({
    required this.id,
    required this.title,
    this.subtitle,
    this.trailing,
    this.imageUrl,
    this.artKind = MediaArtKind.poster,
    this.thumbWidth = 52,
    this.thumbHeight = 78,
  });

  final int id;
  final String title;

  /// Secondary line (e.g. "1973 · Altman"). Null → hidden.
  final String? subtitle;

  /// Right-aligned label (e.g. score "8.1"). Null → hidden.
  final String? trailing;

  final String? imageUrl;
  final MediaArtKind artKind;
  final double thumbWidth;
  final double thumbHeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaRowDisplay &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          trailing == other.trailing &&
          imageUrl == other.imageUrl &&
          artKind == other.artKind &&
          thumbWidth == other.thumbWidth &&
          thumbHeight == other.thumbHeight;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subtitle,
    trailing,
    imageUrl,
    artKind,
    thumbWidth,
    thumbHeight,
  );
}
