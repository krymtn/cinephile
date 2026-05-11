import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/movies/data/remote/mock_data_source.dart';
import 'package:cinephileapp/features/movies/domain/movie_catalog_kind.dart';

import 'mock_support.dart';

void main() {
  ensureMovieMockAssetsBinding();

  late MockMovieRemoteDataSource dataSource;

  setUp(() {
    dataSource = createMockMovieRemoteDataSource();
  });

  group('MockMovieRemoteDataSource now playing', () {
    test('parses dates envelope and first movie', () async {
      final page = await dataSource.fetchCatalog(MovieCatalogKind.nowPlaying);

      expect(page.page, 1);
      expect(page.windowStart, '2026-04-15');
      expect(page.windowEnd, '2026-05-04');
      expect(page.totalPages, 198);
      expect(page.totalResults, 3955);

      final first = page.results.first;
      expect(first.id, 693134);
      expect(first.title, 'Dune: Part Two');
      expect(first.genreIds, [878, 12, 28]);
      expect(first.voteAverage, closeTo(8.193, 0.001));
    });
  });

  group('MockMovieRemoteDataSource popular', () {
    test('has no date window and parses first movie', () async {
      final page = await dataSource.fetchCatalog(MovieCatalogKind.popular);

      expect(page.windowStart, isNull);
      expect(page.windowEnd, isNull);
      expect(page.results.first.id, 27205);
      expect(page.results.first.title, 'Inception');
    });

    test('page > 1 returns empty results with same totals', () async {
      final first = await dataSource.fetchCatalog(MovieCatalogKind.popular);
      final second = await dataSource.fetchCatalog(
        MovieCatalogKind.popular,
        page: 2,
      );

      expect(second.page, 2);
      expect(second.results, isEmpty);
      expect(second.totalPages, first.totalPages);
      expect(second.totalResults, first.totalResults);
    });
  });

  group('MockMovieRemoteDataSource top rated', () {
    test('parses first movie', () async {
      final page = await dataSource.fetchCatalog(MovieCatalogKind.topRated);

      expect(page.results.first.id, 278);
      expect(page.results.first.title, 'The Shawshank Redemption');
    });
  });

  group('MockMovieRemoteDataSource upcoming', () {
    test('parses dates envelope and first movie', () async {
      final page = await dataSource.fetchCatalog(MovieCatalogKind.upcoming);

      expect(page.windowStart, '2026-05-05');
      expect(page.windowEnd, '2026-05-26');
      expect(page.results.first.id, 696506);
      expect(page.results.first.title, 'Mickey 17');
    });
  });
}
