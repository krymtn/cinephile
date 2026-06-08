import '../../../domain/tv_series.dart';
import '../../../domain/tv_series_catalog_kind.dart';

sealed class TvSeriesCatalogState {
  const TvSeriesCatalogState({required this.selectedKind});

  final TvSeriesCatalogKind selectedKind;
}

final class TvSeriesCatalogInitial extends TvSeriesCatalogState {
  const TvSeriesCatalogInitial({required super.selectedKind});
}

final class TvSeriesCatalogLoading extends TvSeriesCatalogState {
  const TvSeriesCatalogLoading({required super.selectedKind});
}

final class TvSeriesCatalogLoaded extends TvSeriesCatalogState {
  const TvSeriesCatalogLoaded({
    required super.selectedKind,
    required this.series,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  final List<TvSeries> series;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  TvSeriesCatalogLoaded copyWith({
    List<TvSeries>? series,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return TvSeriesCatalogLoaded(
      selectedKind: selectedKind,
      series: series ?? this.series,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class TvSeriesCatalogFailure extends TvSeriesCatalogState {
  const TvSeriesCatalogFailure({
    required super.selectedKind,
    required this.error,
    this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;
}
