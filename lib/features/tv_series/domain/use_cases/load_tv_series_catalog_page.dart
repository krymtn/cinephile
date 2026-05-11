import '../../../../core/use_case/use_case.dart';
import '../paged_tv_series.dart';
import '../tv_series_repository.dart';
import 'tv_series_catalog_page_input.dart';

/// Cache-first load of a single catalog page (falls back to sync if needed).
final class LoadTvSeriesCatalogPage
    extends UseCase<TvSeriesCatalogPageInput, PagedTvSeries> {
  LoadTvSeriesCatalogPage(this._repository);

  final TvSeriesRepository _repository;

  @override
  String get name => 'loadTvSeriesCatalogPage';

  @override
  Future<PagedTvSeries> invoke(
    TvSeriesCatalogPageInput input, {
    UseCaseProgress? onProgress,
  }) {
    return _repository.loadCatalog(input.kind, page: input.page);
  }
}
