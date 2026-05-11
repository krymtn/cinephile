import '../../../../core/use_case/use_case.dart';
import '../paged_tv_series.dart';
import '../tv_series_repository.dart';
import 'tv_series_catalog_page_input.dart';

/// Remote-only fetch of a single TMDB catalog page (no local writes).
final class FetchTvSeriesCatalogPage
    extends UseCase<TvSeriesCatalogPageInput, PagedTvSeries> {
  FetchTvSeriesCatalogPage(this._repository);

  final TvSeriesRepository _repository;

  @override
  String get name => 'fetchTvSeriesCatalogPage';

  @override
  Future<PagedTvSeries> invoke(
    TvSeriesCatalogPageInput input, {
    UseCaseProgress? onProgress,
  }) {
    return _repository.fetchCatalog(input.kind, page: input.page);
  }
}
