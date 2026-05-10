import '../../../../core/use_case/use_case.dart';
import '../paged_tv_series.dart';
import '../tv_series_repository.dart';
import 'tv_series_catalog_page_input.dart';

/// Fetches a single catalog page from remote, saves it locally, returns it.
final class SyncTvSeriesCatalogPage
    extends UseCase<TvSeriesCatalogPageInput, PagedTvSeries> {
  SyncTvSeriesCatalogPage(this._repository);

  final TvSeriesRepository _repository;

  @override
  String get name => 'syncTvSeriesCatalogPage';

  @override
  Future<PagedTvSeries> invoke(
    TvSeriesCatalogPageInput input, {
    UseCaseProgress? onProgress,
  }) {
    return _repository.syncCatalog(input.kind, page: input.page);
  }
}
