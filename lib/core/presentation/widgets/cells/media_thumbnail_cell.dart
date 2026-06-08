import 'package:flutter/material.dart';

import '../../../../theme/theme_extension.dart';
import 'media_art.dart';
import 'media_tile_display.dart';

/// A fixed-width, aspect-ratio media tile: art + scrim + title + optional badge.
///
/// Domain-free — takes a [MediaTileDisplay] built by a feature mapper.
/// Works for both portrait (movie poster, 2/3) and landscape (TV backdrop, 16/9).
class MediaThumbnailCell extends StatelessWidget {
  const MediaThumbnailCell({
    super.key,
    required this.display,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final MediaTileDisplay display;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: onTap != null,
      label: display.title,
      child: SizedBox(
        width: display.width,
        child: Material(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: display.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MediaArt(
                    imageUrl: display.imageUrl,
                    artKind: display.artKind,
                  ),
                  const _BottomScrim(),
                  _Overlay(display: display, theme: theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomScrim extends StatelessWidget {
  const _BottomScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
        ),
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({required this.display, required this.theme});

  final MediaTileDisplay display;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (display.badge != null) _Badge(text: display.badge!, theme: theme),
          const Spacer(),
          Text(
            display.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.theme});

  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentDim,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
