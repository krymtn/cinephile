import '../../../../../core/database/models/base_entity.dart';
import '../../../domain/movie_catalog_kind.dart';
import 'schema.dart';

/// Ordered slot on a cached catalog page ([MovieCatalogPageSchema.name]).
class MovieCatalogPageEntity extends BaseEntity {
  MovieCatalogPageEntity({
    required this.id,
    required this.catalogKind,
    required this.page,
    required this.position,
    required this.movieRowId,
  });

  @override
  final String id;

  /// TMDB-style key — use [MovieCatalogKind.wireKey] when building from domain.
  final String catalogKind;
  final int page;

  /// Zero-based index within the page (API order).
  final int position;

  /// Same digits as the linked [MovieSchema] row id.
  final String movieRowId;

  @override
  Map<String, dynamic> toMap() {
    return {
      MovieCatalogPageSchema.id: id,
      MovieCatalogPageSchema.catalogKind: catalogKind,
      MovieCatalogPageSchema.page: page,
      MovieCatalogPageSchema.position: position,
      MovieCatalogPageSchema.movieId: movieRowId,
    };
  }

  factory MovieCatalogPageEntity.fromMap(Map<String, dynamic> map) {
    return MovieCatalogPageEntity(
      id: map[MovieCatalogPageSchema.id] as String,
      catalogKind: map[MovieCatalogPageSchema.catalogKind] as String,
      page: map[MovieCatalogPageSchema.page] as int,
      position: map[MovieCatalogPageSchema.position] as int,
      movieRowId: map[MovieCatalogPageSchema.movieId] as String,
    );
  }
}
