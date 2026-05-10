import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/tv_series/domain/tv_series_catalog_kind.dart';

void main() {
  group('TvSeriesCatalogKind', () {
    test('wireKey matches TMDB /tv/* segments', () {
      expect(TvSeriesCatalogKind.airingToday.wireKey, 'airing_today');
      expect(TvSeriesCatalogKind.onTheAir.wireKey, 'on_the_air');
      expect(TvSeriesCatalogKind.popular.wireKey, 'popular');
      expect(TvSeriesCatalogKind.topRated.wireKey, 'top_rated');
    });
  });
}
