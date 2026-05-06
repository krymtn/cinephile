import '../../../../core/data/paged_dto.dart';
import '../../domain/movie_catalog_kind.dart';
import '../dto/movie_dto.dart';

/// Read-only contract for the remote movie catalog (TMDB list endpoints).
///
/// Returns DTOs (`PagedDto<MovieDto>`) deliberately — the repository owns the
/// DTO → domain and DTO → entity mappings so the data source stays a thin
/// wire-format boundary. Both the real Dio-backed and the fixture-backed
/// mock implementations share this interface.
abstract interface class MovieRemoteDataSource {
  /// Fetches one page of [kind] from the remote API.
  ///
  /// - [page] is 1-based, mirroring TMDB. Defaults to 1.
  /// - [language] follows BCP-47 (e.g. `en-US`, `tr-TR`). When null, the
  ///   server default is used.
  /// - [region] is an ISO 3166-1 country code (e.g. `US`, `TR`). Influences
  ///   the `now_playing` and `upcoming` date windows.
  Future<PagedDto<MovieDto>> fetchCatalog(
    MovieCatalogKind kind, {
    int page = 1,
    String? language,
    String? region,
  });
}
