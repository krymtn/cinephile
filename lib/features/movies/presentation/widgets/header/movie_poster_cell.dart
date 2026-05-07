import 'package:flutter/material.dart';

import '../../../../../core/presentation/presentation.dart';
import '../../../../../theme/theme_extension.dart';
import '../../../domain/movie.dart';

class MoviePosterCell extends StatelessWidget {
  const MoviePosterCell({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 120,
    this.aspectRatio = 2 / 3,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final Movie movie;
  final VoidCallback? onTap;
  final double width;
  final double aspectRatio;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final theme = Theme.of(context);

    return PosterCell(
      onTap: onTap,
      width: width,
      aspectRatio: aspectRatio,
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.posterGradA, colors.posterGradB],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
