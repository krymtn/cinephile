import 'paged_tv_series.dart';
import 'tv_series_catalog_kind.dart';

/// TV feature data contract. Implementations live in the data layer
/// (API + local cache); the domain stays free of HTTP/SQLite types.
///
/// Three intents, kept deliberately separate:
/// - [loadCatalog]: read the local cache only (no network, no writes).
/// - [fetchCatalog]: hit the remote API only (no cache writes).
/// - [syncCatalog]: refresh the cache from the remote and return the
///   freshly persisted page (server wins).
abstract interface class TvSeriesRepository {
  /// Returns the locally cached page for [kind]. May be empty when the cache
  /// is cold; callers should fall back to [syncCatalog] in that case.
  Future<PagedTvSeries> loadCatalog(TvSeriesCatalogKind kind, {int page = 1});

  /// Fetches a fresh page from the remote API for [kind]. Does not touch
  /// the local cache; useful for previews/diagnostics.
  Future<PagedTvSeries> fetchCatalog(TvSeriesCatalogKind kind, {int page = 1});

  /// Pulls [kind] from the remote API, persists it locally, and returns the
  /// resulting page. Intended for app launch, pull-to-refresh and similar.
  Future<PagedTvSeries> syncCatalog(TvSeriesCatalogKind kind, {int page = 1});
}
