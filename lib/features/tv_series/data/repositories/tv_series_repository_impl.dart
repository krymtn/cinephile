import '../../domain/paged_tv_series.dart';
import '../../domain/tv_series_catalog_kind.dart';
import '../../domain/tv_series_repository.dart';
import '../mappers/tv_series_mapper.dart';
import '../remote/data_source.dart';

/// Remote-backed [TvSeriesRepository]. Local cache is not wired yet; [loadCatalog]
/// and [syncCatalog] both fetch from the API until a SQLite layer is added.
class TvSeriesRepositoryImpl implements TvSeriesRepository {
  const TvSeriesRepositoryImpl({required this.remoteDataSource});

  final TvSeriesRemoteDataSource remoteDataSource;

  @override
  Future<PagedTvSeries> loadCatalog(TvSeriesCatalogKind kind, {int page = 1}) {
    return syncCatalog(kind, page: page);
  }

  @override
  Future<PagedTvSeries> fetchCatalog(
    TvSeriesCatalogKind kind, {
    int page = 1,
  }) async {
    final remotePage = await remoteDataSource.fetchCatalog(kind, page: page);
    return remotePage.toDomain();
  }

  @override
  Future<PagedTvSeries> syncCatalog(TvSeriesCatalogKind kind, {int page = 1}) {
    return fetchCatalog(kind, page: page);
  }
}
