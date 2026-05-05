import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/movies/data/remote/mock_data_source.dart';
import 'package:cinephileapp/features/movies/domain/movie_catalog_kind.dart';

import '../support.dart';

void main() {
  ensureMovieMockAssetsBinding();

  late MockMovieRemoteDataSource dataSource;

  setUp(() {
    dataSource = createMockMovieRemoteDataSource();
  });

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
}
