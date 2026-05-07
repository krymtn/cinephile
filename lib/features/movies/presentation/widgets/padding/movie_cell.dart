import 'package:flutter/material.dart';

import '../../../../../core/presentation/presentation.dart';
import '../../../../../theme/theme_extension.dart';
import '../../../domain/movie.dart';

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

  static const double _posterWidth = 52;
  static const double _posterHeight = 78;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MediaCell(
      onTap: onTap,
      padding: padding,
      borderRadius: borderRadius,
      leading: Container(
        width: _posterWidth,
        height: _posterHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.posterGradA, colors.posterGradB],
          ),
        ),
      ),
      title: Text(
        movie.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        _subtitle(movie),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        movie.voteAverage.toStringAsFixed(1),
        style: theme.textTheme.titleSmall?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static String _subtitle(Movie movie) {
    final year = movie.releaseYear;
    final director = movie.directorName;
    if (year == null && (director == null || director.isEmpty)) {
      return '—';
    }
    if (year != null && director != null && director.isNotEmpty) {
      return '$year · $director';
    }
    if (year != null) return '$year';
    return director!;
  }
}

