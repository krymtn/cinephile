/// Sections of the TV catalog mapped to TMDB `/tv/*` list endpoints.
enum TvSeriesCatalogKind {
  airingToday,
  onTheAir,
  popular,
  topRated;

  /// TMDB path segment after `/tv/` (`airing_today`, `on_the_air`, …); same
  /// string can be used for local `catalog_kind` when caching.
  String get wireKey => switch (this) {
    TvSeriesCatalogKind.airingToday => 'airing_today',
    TvSeriesCatalogKind.onTheAir => 'on_the_air',
    TvSeriesCatalogKind.popular => 'popular',
    TvSeriesCatalogKind.topRated => 'top_rated',
  };
}
