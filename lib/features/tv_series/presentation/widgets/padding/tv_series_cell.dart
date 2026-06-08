import 'package:flutter/material.dart';

import '../../../../../core/presentation/widgets/cells/media_row_cell.dart';
import '../../../../../core/presentation/widgets/cells/media_row_skeleton.dart';
import '../../../domain/tv_series.dart';
import '../../mappers/tv_tile_display.dart';

/// Thin wrapper around [MediaRowCell] for TV catalog list rows.
class TvSeriesCell extends StatelessWidget {
  const TvSeriesCell({
    super.key,
    required this.series,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final TvSeries series;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return MediaRowCell(
      display: tvRowDisplay(series),
      onTap: onTap,
      padding: padding,
      borderRadius: borderRadius,
    );
  }
}

/// Shimmer placeholder for [TvSeriesCell].
class TvSeriesCellSkeleton extends StatelessWidget {
  const TvSeriesCellSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediaRowSkeleton();
  }
}
