import '../../domain/movie_catalog_kind.dart';
import '../../domain/movie_repository.dart';
import '../../domain/paged_movies.dart';
import '../local/data_source.dart';
import '../mappers/movie_mapper.dart';
import '../remote/data_source.dart';

/// Concrete implementation of [MovieRepository] that coordinates between
/// the local database cache and the remote TMDB API.
class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final MovieLocalDataSource localDataSource;
  final MovieRemoteDataSource remoteDataSource;

  @override
  Future<PagedMovies> loadCatalog(MovieCatalogKind kind, {int page = 1}) async {
    final cachedPage = await localDataSource.getCatalogPage(kind, page);
    
    if (cachedPage != null) {
      return cachedPage;
    }

    // If cache is empty, fallback to syncing from remote
    return syncCatalog(kind, page: page);
  }

  @override
  Future<PagedMovies> fetchCatalog(MovieCatalogKind kind, {int page = 1}) async {
    final remotePage = await remoteDataSource.fetchCatalog(kind, page: page);
    
    // Map DTOs directly to Domain without saving to cache
    return remotePage.toDomain();
  }

  @override
  Future<PagedMovies> syncCatalog(MovieCatalogKind kind, {int page = 1}) async {
    // 1. Fetch fresh DTOs from remote API
    final remotePage = await remoteDataSource.fetchCatalog(kind, page: page);
    
    // 2. Save DTOs to local database
    await localDataSource.saveCatalogPage(kind, remotePage);
    
    // 3. Convert DTOs to Domain models to return to the UI
    return remotePage.toDomain();
  }
}
