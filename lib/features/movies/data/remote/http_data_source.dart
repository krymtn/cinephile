import '../../../../core/data/paged_dto.dart';
import '../../../../core/network/network_client.dart';
import '../../domain/movie_catalog_kind.dart';
import '../dto/movie_dto.dart';
import 'data_source.dart';

/// Dio-backed [MovieRemoteDataSource] hitting TMDB v3 list endpoints.
///
/// The bearer token and base URL are configured on the shared [NetworkClient]
/// at the composition root (`lib/main.dart`); this class only knows about
/// paths and query parameters.
class HttpMovieRemoteDataSource implements MovieRemoteDataSource {
  HttpMovieRemoteDataSource(this._client);

  final NetworkClient _client;

  @override
  Future<PagedDto<MovieDto>> fetchCatalog(
    MovieCatalogKind kind, {
    int page = 1,
    String? language,
    String? region,
  }) async {
    final response = await _client.get(
      _pathFor(kind),
      queryParameters: {
        'page': page,
        'language': ?language,
        'region': ?region,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Unexpected payload type for ${_pathFor(kind)}: ${data.runtimeType}',
      );
    }

    return pagedMoviesSerializer.fromJson(data);
  }

  String _pathFor(MovieCatalogKind kind) => '/movie/${kind.wireKey}';
}
