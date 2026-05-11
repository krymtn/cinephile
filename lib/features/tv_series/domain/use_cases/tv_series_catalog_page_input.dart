import '../../../../core/use_case/use_case_input.dart';
import '../tv_series_catalog_kind.dart';

final class TvSeriesCatalogPageInput extends UseCaseInput {
  const TvSeriesCatalogPageInput({required this.kind, required this.page});

  final TvSeriesCatalogKind kind;
  final int page;

  @override
  String toString() => 'TvSeriesCatalogPageInput(kind: $kind, page: $page)';
}
