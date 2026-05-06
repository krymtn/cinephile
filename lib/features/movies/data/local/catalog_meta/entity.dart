import '../../../../../core/database/models/base_entity.dart';
import 'schema.dart';

/// Cached TMDB page envelope ([MovieCatalogMetaSchema.name]).
class MovieCatalogMetaEntity extends BaseEntity {
  MovieCatalogMetaEntity({
    required this.id,
    required this.catalogKind,
    required this.page,
    required this.totalPages,
    required this.totalResults,
    this.windowStart,
    this.windowEnd,
    required this.fetchedAt,
  });

  @override
  final String id;

  final String catalogKind;
  final int page;
  final int totalPages;
  final int totalResults;
  final String? windowStart;
  final String? windowEnd;

  /// ISO8601 timestamp of when this page was last fetched from TMDB.
  final String fetchedAt;

  @override
  Map<String, dynamic> toMap() {
    return {
      MovieCatalogMetaSchema.id: id,
      MovieCatalogMetaSchema.catalogKind: catalogKind,
      MovieCatalogMetaSchema.page: page,
      MovieCatalogMetaSchema.totalPages: totalPages,
      MovieCatalogMetaSchema.totalResults: totalResults,
      MovieCatalogMetaSchema.windowStart: windowStart,
      MovieCatalogMetaSchema.windowEnd: windowEnd,
      MovieCatalogMetaSchema.fetchedAt: fetchedAt,
    };
  }

  factory MovieCatalogMetaEntity.fromMap(Map<String, dynamic> map) {
    return MovieCatalogMetaEntity(
      id: map[MovieCatalogMetaSchema.id] as String,
      catalogKind: map[MovieCatalogMetaSchema.catalogKind] as String,
      page: map[MovieCatalogMetaSchema.page] as int,
      totalPages: map[MovieCatalogMetaSchema.totalPages] as int,
      totalResults: map[MovieCatalogMetaSchema.totalResults] as int,
      windowStart: map[MovieCatalogMetaSchema.windowStart] as String?,
      windowEnd: map[MovieCatalogMetaSchema.windowEnd] as String?,
      fetchedAt: map[MovieCatalogMetaSchema.fetchedAt] as String,
    );
  }
}
