import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/presentation/widgets/cells/media_thumbnail_cell.dart';
import '../../../../../theme/theme_extension.dart';
import '../../../domain/movie.dart';
import '../../mappers/movie_tile_display.dart';

/// Horizontal list for the always-on **popular** rail.
class MoviesPopularList extends StatelessWidget {
  const MoviesPopularList({super.key, required this.movies, this.onMovieTap});

  final List<Movie> movies;
  final void Function(Movie movie)? onMovieTap;

  // Derived from movieCarouselDisplay: width 132, aspectRatio 2/3 → height 198.
  static const double _railHeight = 198;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const MoviesPopularListSkeleton();
    }

    return SizedBox(
      height: _railHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MediaThumbnailCell(
            display: movieCarouselDisplay(movie),
            onTap: onMovieTap != null ? () => onMovieTap!(movie) : null,
          );
        },
      ),
    );
  }
}

/// Horizontal list placeholder for the always-on **popular** rail.
class MoviesPopularListSkeleton extends StatelessWidget {
  const MoviesPopularListSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  static const double _cardWidth = 132;
  static const double _cardHeight = 198;
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
