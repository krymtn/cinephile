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
    final page = await dataSource.fetchCatalog(MovieCatalogKind.upcoming);

    expect(page.windowStart, '2026-05-05');
    expect(page.windowEnd, '2026-05-26');
    expect(page.results.first.id, 696506);
    expect(page.results.first.title, 'Mickey 17');
  });
}
