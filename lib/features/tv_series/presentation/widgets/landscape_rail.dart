import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/presentation/widgets/cells/media_thumbnail_cell.dart';
import '../../../../theme/theme_extension.dart';
import '../../domain/tv_series.dart';
import '../mappers/tv_tile_display.dart';

/// Horizontal landscape rail for a TV catalog section (backdrop tiles, 16/9).
class TvSeriesLandscapeRail extends StatelessWidget {
  const TvSeriesLandscapeRail({
    super.key,
    required this.series,
    this.onSeriesTap,
  });

  final List<TvSeries> series;
  final void Function(TvSeries series)? onSeriesTap;

  // Derived from tvCarouselDisplay: width 168, aspectRatio 16/9 → height 94.5.
  static const double _railHeight = 94.5;

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) {
      return const TvSeriesLandscapeRailSkeleton();
    }

    return SizedBox(
      height: _railHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: series.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final show = series[index];
          return MediaThumbnailCell(
            display: tvCarouselDisplay(show),
            onTap: onSeriesTap != null ? () => onSeriesTap!(show) : null,
          );
        },
      ),
    );
  }
}

/// Shimmer placeholder for [TvSeriesLandscapeRail].
class TvSeriesLandscapeRailSkeleton extends StatelessWidget {
  const TvSeriesLandscapeRailSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  static const double _cardWidth = 168;
  static const double _cardHeight = 94.5;
  static const double _radius = 14;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _cardHeight + 8,
      child: Shimmer.fromColors(
        baseColor: scheme.surfaceContainerHighest,
        highlightColor: scheme.surfaceContainerHigh,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return Container(
              width: _cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_radius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.posterGradA, colors.posterGradB],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
