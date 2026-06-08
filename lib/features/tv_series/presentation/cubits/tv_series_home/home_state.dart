import '../../../domain/tv_series.dart';
import '../../../domain/tv_series_catalog_kind.dart';
import '../../tv_home_sections.dart';

sealed class TvSectionState {
  const TvSectionState();
}

final class TvSectionInitial extends TvSectionState {
  const TvSectionInitial();
}

final class TvSectionLoading extends TvSectionState {
  const TvSectionLoading();
}

final class TvSectionLoaded extends TvSectionState {
  const TvSectionLoaded(this.series);

  final List<TvSeries> series;
}

final class TvSectionFailure extends TvSectionState {
  const TvSectionFailure(this.error, {this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;
}

/// Home tab state: one entry per [tvHomeSectionKinds] catalog section.
final class TvSeriesHomeState {
  const TvSeriesHomeState({required this.sections});

  final Map<TvSeriesCatalogKind, TvSectionState> sections;

  factory TvSeriesHomeState.initial() {
    return TvSeriesHomeState(
      sections: {
        for (final kind in tvHomeSectionKinds) kind: const TvSectionInitial(),
      },
    );
  }

  factory TvSeriesHomeState.loading() {
    return TvSeriesHomeState(
      sections: {
        for (final kind in tvHomeSectionKinds) kind: const TvSectionLoading(),
      },
    );
  }

  TvSeriesHomeState copyWithSection(
    TvSeriesCatalogKind kind,
    TvSectionState section,
  ) {
    return TvSeriesHomeState(sections: {...sections, kind: section});
  }
}
