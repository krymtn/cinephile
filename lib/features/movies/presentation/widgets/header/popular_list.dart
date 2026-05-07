import 'package:flutter/material.dart';

import '../../../../../theme/theme_extension.dart';

/// Horizontal list placeholder for the always-on **popular** rail.
class MoviesPopularListSkeleton extends StatelessWidget {
  const MoviesPopularListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  static const double _cardWidth = 120;
  static const double _cardHeight = 180;
  static const double _radius = 14;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final accent = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: _cardHeight + 8,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final selected = index == 0;
          return Container(
            width: _cardWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.posterGradA, colors.posterGradB],
              ),
              border: Border.all(
                color: selected
                    ? accent
                    : Theme.of(context).colorScheme.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${7.6 - index * 0.1}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Title ${index + 1}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

