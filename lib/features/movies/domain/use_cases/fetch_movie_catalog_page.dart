import '../../../../core/use_case/use_case.dart';
import '../movie_repository.dart';
import '../paged_movies.dart';
import 'movie_catalog_page_input.dart';

/// Remote-only fetch of a single TMDB catalog page (no local writes).
final class FetchMovieCatalogPage
    extends UseCase<MovieCatalogPageInput, PagedMovies> {
  FetchMovieCatalogPage(this._repository);

  final MovieRepository _repository;

  @override
  String get name => 'fetchMovieCatalogPage';

  @override
  Future<PagedMovies> invoke(
    MovieCatalogPageInput input, {
    UseCaseProgress? onProgress,
  }) {
    return _repository.fetchCatalog(input.kind, page: input.page);
  }
}
