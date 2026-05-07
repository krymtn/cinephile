import '../../../../core/use_case/use_case.dart';
import '../movie_repository.dart';
import '../paged_movies.dart';
import 'movie_catalog_page_input.dart';

/// Cache-first load of a single catalog page (falls back to sync if needed).
final class LoadMovieCatalogPage
    extends UseCase<MovieCatalogPageInput, PagedMovies> {
  LoadMovieCatalogPage(this._repository);

  final MovieRepository _repository;

  @override
  String get name => 'loadMovieCatalogPage';

  @override
  Future<PagedMovies> invoke(
    MovieCatalogPageInput input, {
    UseCaseProgress? onProgress,
  }) {
    return _repository.loadCatalog(input.kind, page: input.page);
  }
}
