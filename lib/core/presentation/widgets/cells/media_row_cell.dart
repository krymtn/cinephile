import 'package:flutter/material.dart';

import 'media_art.dart';
import 'media_row_display.dart';

/// A list row: thumbnail art + title + optional subtitle + optional trailing score.
///
/// Domain-free — takes a [MediaRowDisplay] built by a feature mapper.
class MediaRowCell extends StatelessWidget {
  const MediaRowCell({
    super.key,
    required this.display,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final MediaRowDisplay display;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: onTap != null,
      label: display.subtitle == null
          ? display.title
          : '${display.title}, ${display.subtitle}',
      child: Material(
        color: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: scheme.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: display.thumbWidth,
                    height: display.thumbHeight,
                    child: MediaArt(
                      imageUrl: display.imageUrl,
                      artKind: display.artKind,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        display.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (display.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          display.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (display.trailing != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    display.trailing!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
