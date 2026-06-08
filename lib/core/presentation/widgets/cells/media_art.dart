import 'package:flutter/material.dart';

import '../../../../theme/theme_extension.dart';
import 'media_tile_display.dart';

/// Fills its parent with media art, falling back to a themed gradient when
/// [imageUrl] is null, empty, or fails to load.
///
/// Owns the image async/error state so [MediaThumbnailCell] stays stateless.
class MediaArt extends StatelessWidget {
  const MediaArt({super.key, required this.imageUrl, required this.artKind});

  final String? imageUrl;
  final MediaArtKind artKind;

  @override
  Widget build(BuildContext context) {
    final fallback = _GradientFallback(artKind: artKind);
    final url = imageUrl;

    if (url == null || url.isEmpty) return fallback;

    return Image.network(
      url,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : fallback,
      errorBuilder: (context, error, stack) => fallback,
    );
  }
}

class _GradientFallback extends StatelessWidget {
  const _GradientFallback({required this.artKind});

  final MediaArtKind artKind;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final (a, b) = switch (artKind) {
      MediaArtKind.poster => (colors.posterGradA, colors.posterGradB),
      MediaArtKind.backdrop => (colors.thumbGradA, colors.thumbGradB),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [a, b],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
