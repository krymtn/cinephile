import '../../../../core/use_case/use_case_input.dart';
import '../movie_catalog_kind.dart';

final class MovieCatalogPageInput extends UseCaseInput {
  const MovieCatalogPageInput({required this.kind, required this.page});

  final MovieCatalogKind kind;
  final int page;

  @override
  String toString() => 'MovieCatalogPageInput(kind: $kind, page: $page)';
}
