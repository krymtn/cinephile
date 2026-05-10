import '../../../../core/data/paged_dto.dart';
import '../../../../core/network/network_client.dart';
import '../../domain/tv_series_catalog_kind.dart';
import '../dto/tv_series_dto.dart';
import 'data_source.dart';

/// Dio-backed [TvSeriesRemoteDataSource] for TMDB v3 TV list endpoints.
class HttpTvSeriesRemoteDataSource implements TvSeriesRemoteDataSource {
  HttpTvSeriesRemoteDataSource(this._client);

  final NetworkClient _client;

  @override
  Future<PagedDto<TvSeriesDto>> fetchCatalog(
    TvSeriesCatalogKind kind, {
    int page = 1,
    String? language,
    String? region,
  }) async {
    final response = await _client.get(
      _pathFor(kind),
      queryParameters: {'page': page, 'language': ?language, 'region': ?region},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Unexpected payload type for ${_pathFor(kind)}: ${data.runtimeType}',
      );
    }

    return pagedTvSeriesSerializer.fromJson(data);
  }

  String _pathFor(TvSeriesCatalogKind kind) => '/tv/${kind.wireKey}';
}
