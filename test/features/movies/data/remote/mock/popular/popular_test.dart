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

  test('has no date window and parses first movie', () async {
    final page = await dataSource.fetchCatalog(MovieCatalogKind.popular);

    expect(page.windowStart, isNull);
    expect(page.windowEnd, isNull);
    expect(page.results.first.id, 27205);
    expect(page.results.first.title, 'Inception');
  });
}
