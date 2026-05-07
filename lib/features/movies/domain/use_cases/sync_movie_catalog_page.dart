import '../../../../core/use_case/use_case.dart';
import '../movie_repository.dart';
import '../paged_movies.dart';
import 'movie_catalog_page_input.dart';

/// Fetches a single catalog page from remote, saves it locally, returns it.
final class SyncMovieCatalogPage
    extends UseCase<MovieCatalogPageInput, PagedMovies> {
  SyncMovieCatalogPage(this._repository);

  final MovieRepository _repository;

  @override
  String get name => 'syncMovieCatalogPage';

  @override
  Future<PagedMovies> invoke(
    MovieCatalogPageInput input, {
    UseCaseProgress? onProgress,
  }) {
    return _repository.syncCatalog(input.kind, page: input.page);
  }
}
