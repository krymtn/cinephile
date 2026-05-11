import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/tv_series/data/remote/mock_data_source.dart';
import 'package:cinephileapp/features/tv_series/domain/tv_series_catalog_kind.dart';

import 'mock_support.dart';

void main() {
  ensureTvSeriesMockAssetsBinding();

  late MockTvSeriesRemoteDataSource dataSource;

  setUp(() {
    dataSource = createMockTvSeriesRemoteDataSource();
  });

  group('MockTvSeriesRemoteDataSource top rated', () {
    test('parses first show and shared list fields', () async {
      final page = await dataSource.fetchCatalog(TvSeriesCatalogKind.topRated);

      expect(page.page, 1);
      expect(page.totalPages, 142);
      expect(page.totalResults, 2833);

      final first = page.results.first;
      expect(first.id, 130392);
      expect(first.name, "The D'Amelio Show");
      expect(first.originalName, "The D'Amelio Show");
      expect(first.firstAirDate, '2021-09-03');
      expect(first.originCountry, ['US']);
      expect(first.genreIds, [10764]);
      expect(first.voteAverage, closeTo(8.9, 0.001));
    });
  });

  group('MockTvSeriesRemoteDataSource airing today', () {
    test('parses first show', () async {
      final page = await dataSource.fetchCatalog(
        TvSeriesCatalogKind.airingToday,
      );

      expect(page.results.first.id, 1396);
      expect(page.results.first.name, 'Breaking Bad');
    });
  });

  group('MockTvSeriesRemoteDataSource popular pagination', () {
    test('page > 1 returns empty results with same totals', () async {
      final first = await dataSource.fetchCatalog(TvSeriesCatalogKind.popular);
      final second = await dataSource.fetchCatalog(
        TvSeriesCatalogKind.popular,
        page: 2,
      );

      expect(second.page, 2);
      expect(second.results, isEmpty);
      expect(second.totalPages, first.totalPages);
      expect(second.totalResults, first.totalResults);
    });
  });
}
