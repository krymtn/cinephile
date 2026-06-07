import 'package:flutter/foundation.dart';

/// Which TMDB art a tile prefers — drives aspect ratio defaults and the
/// gradient fallback colour pair in [MediaArt].
enum MediaArtKind { poster, backdrop }

/// Flat, domain-free data for a single media thumbnail tile.
///
/// Feature mappers (`Movie` / `TvSeries` → [MediaTileDisplay]) live in each
/// feature package. The core cell widget never imports a domain type.
///
/// All fields are presentation-ready (formatted strings, full image URLs).
@immutable
class MediaTileDisplay {
  const MediaTileDisplay({
    required this.id,
    required this.title,
    this.badge,
    this.imageUrl,
    this.artKind = MediaArtKind.poster,
    this.aspectRatio = 2 / 3,
    this.width = 120,
  });

  /// Stable identity used for [ValueKey]s and tap callbacks on the screen.
  final int id;

  /// Primary label shown on the tile.
  final String title;

  /// Short overlay label (e.g. score "8.7"). Null → badge hidden.
  final String? badge;

  /// Fully-composed image URL. Null or empty → gradient-only fallback.
  final String? imageUrl;

  /// Preferred art orientation — influences gradient fallback colours.
  final MediaArtKind artKind;

  /// Width-to-height ratio: `2/3` for portrait posters, `16/9` for backdrops.
  final double aspectRatio;

  /// Fixed tile width in logical pixels.
  final double width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaTileDisplay &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          badge == other.badge &&
          imageUrl == other.imageUrl &&
          artKind == other.artKind &&
          aspectRatio == other.aspectRatio &&
          width == other.width;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        badge,
        imageUrl,
        artKind,
        aspectRatio,
        width,
      );

  @override
  String toString() => 'MediaTileDisplay('
      'id: $id, title: $title, badge: $badge, '
      'artKind: $artKind, aspectRatio: $aspectRatio, width: $width)';
}
