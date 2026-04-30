import '../../../../core/database/models/base_entity.dart';
import '../../../../core/database/database_constants.dart';
import '../dao/movie_dao_schema.dart';

class MovieEntity implements BaseEntity {
  @override
  final String id;
  final String title;
  final String? overview;
  final double rating;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String? syncId;
  @override
  final int syncStatus;

  MovieEntity({
    required this.id,
    required this.title,
    this.overview,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.syncStatus = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      BaseColumns.id: id,
      MovieDaoSchema.colTitle: title,
      MovieDaoSchema.colOverview: overview,
      MovieDaoSchema.colRating: rating,
      BaseColumns.createdAt: createdAt.toIso8601String(),
      BaseColumns.updatedAt: updatedAt.toIso8601String(),
      BaseColumns.deletedAt: deletedAt?.toIso8601String(),
      BaseColumns.syncId: syncId,
      BaseColumns.syncStatus: syncStatus,
    };
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: map[BaseColumns.id],
      title: map[MovieDaoSchema.colTitle],
      overview: map[MovieDaoSchema.colOverview],
      rating: map[MovieDaoSchema.colRating] ?? 0.0,
      createdAt: DateTime.parse(map[BaseColumns.createdAt]),
      updatedAt: DateTime.parse(map[BaseColumns.updatedAt]),
      deletedAt: map[BaseColumns.deletedAt] != null
          ? DateTime.parse(map[BaseColumns.deletedAt])
          : null,
      syncId: map[BaseColumns.syncId],
      syncStatus: map[BaseColumns.syncStatus],
    );
  }
}
