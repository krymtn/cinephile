import '../domain/tv_series_catalog_kind.dart';

/// Fixed section order for the TV series home tab (stacked landscape rails).
const List<TvSeriesCatalogKind> tvHomeSectionKinds = [
  TvSeriesCatalogKind.airingToday,
  TvSeriesCatalogKind.onTheAir,
  TvSeriesCatalogKind.popular,
  TvSeriesCatalogKind.topRated,
];

String tvSectionTitle(TvSeriesCatalogKind kind) {
  return switch (kind) {
    TvSeriesCatalogKind.airingToday => 'Airing today',
    TvSeriesCatalogKind.onTheAir => 'On the air',
    TvSeriesCatalogKind.popular => 'Popular',
    TvSeriesCatalogKind.topRated => 'Top rated',
  };
}
