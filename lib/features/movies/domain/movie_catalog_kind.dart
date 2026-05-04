/// Sections of the Movies screen mapped to TMDB-style discovery endpoints.
enum MovieCatalogKind {
  nowPlaying,
  popular,
  topRated,
  upcoming;

  /// TMDB list suffix after `/movie/` (`now_playing`, `top_rated`, …); same
  /// string used for local `catalog_kind` (`movie_catalog_pages`, …).
  String get wireKey => switch (this) {
        MovieCatalogKind.nowPlaying => 'now_playing',
        MovieCatalogKind.popular => 'popular',
        MovieCatalogKind.topRated => 'top_rated',
        MovieCatalogKind.upcoming => 'upcoming',
      };
}
