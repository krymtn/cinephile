import 'package:flutter/material.dart';

import '../../../movies/presentation/widgets/movies_section_heading.dart';
import '../../domain/tv_series.dart';
import '../cubits/tv_series_home/home_state.dart';
import 'landscape_rail.dart';

/// One home-tab block: section heading, optional See all, and a landscape rail.
class TvSeriesCatalogSection extends StatelessWidget {
  const TvSeriesCatalogSection({
    super.key,
    required this.title,
    required this.sectionState,
    this.onSeeAll,
    this.onSeriesTap,
  });

  final String title;
  final TvSectionState sectionState;
  final VoidCallback? onSeeAll;
  final void Function(TvSeries series)? onSeriesTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MoviesSectionHeading(title: title, onSeeAll: onSeeAll),
        switch (sectionState) {
          TvSectionLoaded(:final series) => TvSeriesLandscapeRail(
            series: series,
            onSeriesTap: onSeriesTap,
          ),
          TvSectionFailure() => const TvSeriesLandscapeRailSkeleton(),
          _ => const TvSeriesLandscapeRailSkeleton(),
        },
      ],
    );
  }
}
