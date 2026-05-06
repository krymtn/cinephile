import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:cinephileapp/core/data/paged_dto.dart';
import 'package:cinephileapp/features/movies/data/dto/movie_dto.dart';
import 'package:cinephileapp/features/movies/data/local/data_source.dart';
import 'package:cinephileapp/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:cinephileapp/features/movies/data/remote/data_source.dart';
import 'package:cinephileapp/features/movies/domain/movie.dart';
import 'package:cinephileapp/features/movies/domain/movie_catalog_kind.dart';
import 'package:cinephileapp/features/movies/domain/paged_movies.dart';

import 'movie_repository_impl_test.mocks.dart';

@GenerateMocks([MovieLocalDataSource, MovieRemoteDataSource])
void main() {
  group('MovieRepositoryImpl', () {
    test('loadCatalog returns cached page when available', () async {
      final local = MockMovieLocalDataSource();
      final remote = MockMovieRemoteDataSource();

      final cachedPage = PagedMovies(
        movies: const [
          Movie(id: 1, title: 'Cached'),
        ],
        page: 1,
        totalPages: 10,
        totalResults: 100,
      );

      when(local.getCatalogPage(MovieCatalogKind.popular, 1))
          .thenAnswer((_) async => cachedPage);

      final repo = MovieRepositoryImpl(localDataSource: local, remoteDataSource: remote);

      final result = await repo.loadCatalog(MovieCatalogKind.popular, page: 1);
      expect(result, same(cachedPage));

      verify(local.getCatalogPage(MovieCatalogKind.popular, 1)).called(1);
      verifyZeroInteractions(remote);
    });

    test('loadCatalog falls back to syncCatalog when cache is empty', () async {
      final local = MockMovieLocalDataSource();
      final remote = MockMovieRemoteDataSource();

      when(local.getCatalogPage(MovieCatalogKind.popular, 1))
          .thenAnswer((_) async => null);

      final remoteDtoPage = PagedDto<MovieDto>(
        page: 1,
        results: const [MovieDto(id: 7, title: 'Remote')],
        totalPages: 2,
        totalResults: 20,
      );

      when(remote.fetchCatalog(MovieCatalogKind.popular, page: 1))
          .thenAnswer((_) async => remoteDtoPage);
      when(local.saveCatalogPage(MovieCatalogKind.popular, remoteDtoPage))
          .thenAnswer((_) async {});

      final repo = MovieRepositoryImpl(localDataSource: local, remoteDataSource: remote);

      final result = await repo.loadCatalog(MovieCatalogKind.popular, page: 1);
      expect(result.movies.single.id, 7);
      expect(result.movies.single.title, 'Remote');

      verify(local.getCatalogPage(MovieCatalogKind.popular, 1)).called(1);
      verify(remote.fetchCatalog(MovieCatalogKind.popular, page: 1)).called(1);
      verify(local.saveCatalogPage(MovieCatalogKind.popular, remoteDtoPage)).called(1);
    });
  });
}

