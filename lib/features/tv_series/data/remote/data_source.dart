import '../../../../core/data/paged_dto.dart';
import '../../domain/tv_series_catalog_kind.dart';
import '../dto/tv_series_dto.dart';

/// Read-only contract for the remote TV catalog (TMDB `/tv/*` list endpoints).
///
/// Returns DTOs (`PagedDto<TvSeriesDto>`) deliberately — the repository owns
/// DTO → domain / entity mapping; this layer stays a thin wire boundary.
abstract interface class TvSeriesRemoteDataSource {
  /// Fetches one page of [kind] from the remote API.
  ///
  /// - [page] is 1-based, mirroring TMDB. Defaults to 1.
  /// - [language] is BCP-47 (e.g. `en-US`). When null, the server default applies.
  /// - [region] is passed for parity with movies; TMDB may ignore it on some TV routes.
  Future<PagedDto<TvSeriesDto>> fetchCatalog(
    TvSeriesCatalogKind kind, {
    int page = 1,
    String? language,
    String? region,
  });
}
