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
}
