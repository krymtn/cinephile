import '../../../../core/data/paged_dto.dart';
import '../../domain/movie.dart';
import '../../domain/movie_catalog_kind.dart';
import '../../domain/paged_movies.dart';
import '../dto/movie_dto.dart';
import '../mappers/movie_mapper.dart';
import 'catalog_meta/dao.dart';
import 'catalog_meta/entity.dart';
import 'catalog_page/dao.dart';
import 'genre/dao.dart';
import 'movie/dao.dart';

/// Coordinates local database operations for the movies feature.
abstract interface class MovieLocalDataSource {
  /// Returns a cached page of movies, or null if the page is not cached.
  Future<PagedMovies?> getCatalogPage(MovieCatalogKind kind, int page);

  /// Saves a freshly fetched page of movies to the local database.
  Future<void> saveCatalogPage(
    MovieCatalogKind kind,
    PagedDto<MovieDto> remotePage,
  );
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  const MovieLocalDataSourceImpl({
    required this.movieDao,
    required this.genreDao,
    required this.catalogPageDao,
    required this.catalogMetaDao,
  });

  final MovieDao movieDao;
  final MovieGenreDao genreDao;
  final MovieCatalogPageDao catalogPageDao;
  final MovieCatalogMetaDao catalogMetaDao;

  @override
  Future<PagedMovies?> getCatalogPage(MovieCatalogKind kind, int page) async {
    final meta = await catalogMetaDao.get(
      catalogKind: kind.wireKey,
      page: page,
    );

    if (meta == null) {
      return null; // Cache miss
    }

    final slots = await catalogPageDao.listSlots(
      catalogKind: kind.wireKey,
      page: page,
    );

    final movies = <Movie>[];
    for (final slot in slots) {
      final movieId = int.parse(slot.movieRowId);
      final movieEntity = await movieDao.getByMovieId(movieId);
      if (movieEntity != null) {
        // Map the entity to domain. (If genres are needed, we can fetch them via genreDao)
        movies.add(movieEntity.toDomain());
      }
    }

    return PagedMovies(
      movies: movies,
      page: meta.page,
      totalPages: meta.totalPages,
      totalResults: meta.totalResults,
      windowStart: meta.windowStart != null
          ? DateTime.tryParse(meta.windowStart!)
          : null,
      windowEnd: meta.windowEnd != null
          ? DateTime.tryParse(meta.windowEnd!)
          : null,
    );
  }

  @override
  Future<void> saveCatalogPage(
    MovieCatalogKind kind,
    PagedDto<MovieDto> remotePage,
  ) async {
    final now = DateTime.now().toIso8601String();

    // 1. Save all movies and their genres
    for (final dto in remotePage.results) {
      await movieDao.insert(dto.toEntity());
      await genreDao.replaceForMovie(dto.id, dto.genreIds);
    }

    // 2. Save the catalog page slots (this handles its own transaction internally)
    await catalogPageDao.replacePage(
      catalogKind: kind.wireKey,
      page: remotePage.page,
      orderedMovieIds: remotePage.results.map((m) => m.id).toList(),
    );

    // 3. Save the catalog metadata
    await catalogMetaDao.upsert(
      MovieCatalogMetaEntity(
        id: '${kind.wireKey}_${remotePage.page}',
        catalogKind: kind.wireKey,
        page: remotePage.page,
        totalPages: remotePage.totalPages,
        totalResults: remotePage.totalResults,
        windowStart: remotePage.windowStart,
        windowEnd: remotePage.windowEnd,
        fetchedAt: now,
      ),
    );
  }
}
