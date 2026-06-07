import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/cells/media_row_cell.dart';
import '../../../../../core/presentation/widgets/cells/media_row_skeleton.dart';
import '../../../domain/movie.dart';
import '../../mappers/movie_tile_display.dart';

/// Thin wrapper around [MediaRowCell] for movie catalog list rows.
class MovieCell extends StatelessWidget {
  const MovieCell({
    super.key,
    required this.movie,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final Movie movie;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return MediaRowCell(
      display: movieRowDisplay(movie),
      onTap: onTap,
      padding: padding,
      borderRadius: borderRadius,
    );
  }
}

/// Shimmer placeholder for [MovieCell].
class MovieCellSkeleton extends StatelessWidget {
  const MovieCellSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaRowSkeleton();
  }
}
