import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:cinephileapp/core/data/paged_dto.dart';
import 'package:cinephileapp/features/movies/data/dto/movie_dto.dart';
import 'package:cinephileapp/features/movies/data/local/catalog_meta/dao.dart';
import 'package:cinephileapp/features/movies/data/local/catalog_meta/entity.dart';
import 'package:cinephileapp/features/movies/data/local/catalog_page/dao.dart';
import 'package:cinephileapp/features/movies/data/local/catalog_page/entity.dart';
import 'package:cinephileapp/features/movies/data/local/data_source.dart';
import 'package:cinephileapp/features/movies/data/local/genre/dao.dart';
import 'package:cinephileapp/features/movies/data/local/movie/dao.dart';
import 'package:cinephileapp/features/movies/data/local/movie/entity.dart';
import 'package:cinephileapp/features/movies/domain/movie_catalog_kind.dart';

import 'movie_local_data_source_test.mocks.dart';

@GenerateMocks([MovieDao, MovieGenreDao, MovieCatalogPageDao, MovieCatalogMetaDao])
void main() {
  group('MovieLocalDataSourceImpl', () {
    test('getCatalogPage returns null when meta is missing (cache miss)', () async {
      final movieDao = MockMovieDao();
      final genreDao = MockMovieGenreDao();
      final catalogPageDao = MockMovieCatalogPageDao();
      final catalogMetaDao = MockMovieCatalogMetaDao();

      when(
        catalogMetaDao.get(catalogKind: anyNamed('catalogKind'), page: anyNamed('page')),
      ).thenAnswer((_) async => null);

      final ds = MovieLocalDataSourceImpl(
        movieDao: movieDao,
        genreDao: genreDao,
        catalogPageDao: catalogPageDao,
        catalogMetaDao: catalogMetaDao,
      );

      final result = await ds.getCatalogPage(MovieCatalogKind.popular, 1);
      expect(result, isNull);
      verify(
        catalogMetaDao.get(catalogKind: MovieCatalogKind.popular.wireKey, page: 1),
      ).called(1);
      verifyNoMoreInteractions(catalogMetaDao);
    });

    test('getCatalogPage returns movies in slot order when cached', () async {
      final movieDao = MockMovieDao();
      final genreDao = MockMovieGenreDao();
      final catalogPageDao = MockMovieCatalogPageDao();
      final catalogMetaDao = MockMovieCatalogMetaDao();

      when(
        catalogMetaDao.get(catalogKind: anyNamed('catalogKind'), page: anyNamed('page')),
      ).thenAnswer(
        (_) async => MovieCatalogMetaEntity(
          id: 'popular_1',
          catalogKind: 'popular',
          page: 1,
          totalPages: 10,
          totalResults: 100,
          windowStart: null,
          windowEnd: null,
          fetchedAt: '2026-05-06T00:00:00.000Z',
        ),
      );

      when(
        catalogPageDao.listSlots(catalogKind: anyNamed('catalogKind'), page: anyNamed('page')),
      ).thenAnswer(
        (_) async => [
          MovieCatalogPageEntity(
            id: 'popular_1_0',
            catalogKind: 'popular',
            page: 1,
            position: 0,
            movieRowId: '2',
          ),
          MovieCatalogPageEntity(
            id: 'popular_1_1',
            catalogKind: 'popular',
            page: 1,
            position: 1,
            movieRowId: '1',
          ),
        ],
      );

      when(movieDao.getByMovieId(2)).thenAnswer(
        (_) async => MovieEntity(id: '2', title: 'Second'),
      );
      when(movieDao.getByMovieId(1)).thenAnswer(
        (_) async => MovieEntity(id: '1', title: 'First'),
      );

      final ds = MovieLocalDataSourceImpl(
        movieDao: movieDao,
        genreDao: genreDao,
        catalogPageDao: catalogPageDao,
        catalogMetaDao: catalogMetaDao,
      );

      final result = await ds.getCatalogPage(MovieCatalogKind.popular, 1);
      expect(result, isNotNull);
      expect(result!.page, 1);
      expect(result.totalPages, 10);
      expect(result.totalResults, 100);
      expect(result.movies.map((m) => m.id).toList(), [2, 1]);
      expect(result.movies.map((m) => m.title).toList(), ['Second', 'First']);
    });

    test('saveCatalogPage writes movies, genres, slots, and meta', () async {
      final movieDao = MockMovieDao();
      final genreDao = MockMovieGenreDao();
      final catalogPageDao = MockMovieCatalogPageDao();
      final catalogMetaDao = MockMovieCatalogMetaDao();

      final remotePage = PagedDto<MovieDto>(
        page: 1,
        results: const [
          MovieDto(id: 1, title: 'One', genreIds: [10, 20]),
          MovieDto(id: 2, title: 'Two', genreIds: [20]),
        ],
        totalPages: 3,
        totalResults: 6,
        windowStart: null,
        windowEnd: null,
      );

      when(movieDao.insert(any)).thenAnswer((_) async {});
      when(genreDao.replaceForMovie(any, any)).thenAnswer((_) async {});
      when(
        catalogPageDao.replacePage(
          catalogKind: anyNamed('catalogKind'),
          page: anyNamed('page'),
          orderedMovieIds: anyNamed('orderedMovieIds'),
        ),
      ).thenAnswer((_) async {});
      when(catalogMetaDao.upsert(any)).thenAnswer((_) async {});

      final ds = MovieLocalDataSourceImpl(
        movieDao: movieDao,
        genreDao: genreDao,
        catalogPageDao: catalogPageDao,
        catalogMetaDao: catalogMetaDao,
      );

      await ds.saveCatalogPage(MovieCatalogKind.popular, remotePage);

      verify(movieDao.insert(any)).called(2);
      verify(genreDao.replaceForMovie(1, [10, 20])).called(1);
      verify(genreDao.replaceForMovie(2, [20])).called(1);

      verify(
        catalogPageDao.replacePage(
          catalogKind: MovieCatalogKind.popular.wireKey,
          page: 1,
          orderedMovieIds: [1, 2],
        ),
      ).called(1);

      verify(catalogMetaDao.upsert(any)).called(1);
    });
  });
}

