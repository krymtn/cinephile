import 'movie_catalog_kind.dart';
import 'paged_movies.dart';

/// Movies feature data contract. Implementations live in the data layer
/// (API + local cache); the domain stays free of HTTP/SQLite types.
///
/// Three intents, kept deliberately separate:
/// - [loadCatalog]: read the local cache only (no network, no writes).
/// - [fetchCatalog]: hit the remote API only (no cache writes).
/// - [syncCatalog]: refresh the cache from the remote and return the
///   freshly persisted page (server wins).
abstract interface class MovieRepository {
  /// Returns the locally cached page for [kind]. May be empty when the cache
  /// is cold; callers should fall back to [syncCatalog] in that case.
  Future<PagedMovies> loadCatalog(MovieCatalogKind kind, {int page = 1});

  /// Fetches a fresh page from the remote API for [kind]. Does not touch
  /// the local cache; useful for previews/diagnostics.
  Future<PagedMovies> fetchCatalog(MovieCatalogKind kind, {int page = 1});

  /// Pulls [kind] from the remote API, persists it locally, and returns the
  /// resulting page. Intended for app launch, pull-to-refresh and similar.
  Future<PagedMovies> syncCatalog(MovieCatalogKind kind, {int page = 1});
}
