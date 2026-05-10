import 'tv_series.dart';

/// One page from a paginated TV list API (e.g. popular, top rated).
class PagedTvSeries {
  const PagedTvSeries({
    required this.series,
    required this.page,
    required this.totalPages,
    required this.totalResults,
    this.windowStart,
    this.windowEnd,
  });

  final List<TvSeries> series;
  final int page;
  final int totalPages;
  final int totalResults;

  /// Optional date window when the API returns a `dates` envelope (mirrors
  /// [PagedMovies]; rare on TV lists but kept for a uniform catalog shape).
  final DateTime? windowStart;
  final DateTime? windowEnd;
}
