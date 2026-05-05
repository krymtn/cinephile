import '../../../../../core/database/database_constants.dart';
import '../../../../../core/database/models/base_entity.dart';
import 'schema.dart';

/// Cached TMDB summary row in [MoviesTable.name].
class MovieEntity extends BaseEntity {
  MovieEntity({
    required this.id,
    required this.title,
    this.originalTitle,
    this.originalLanguage,
    this.overview,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    this.popularity = 0,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.adult = false,
    this.video = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.syncId,
    this.syncStatus = 0,
  });

  int get movieId => int.parse(id);

  @override
  final String id;

  final String title;
  final String? originalTitle;
  final String? originalLanguage;
  final String? overview;
  final String? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final bool video;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? syncId;
  final int syncStatus;

  @override
  Map<String, dynamic> toMap() {
    return {
      MoviesTable.id: id,
      MoviesTable.title: title,
      MoviesTable.originalTitle: originalTitle,
      MoviesTable.originalLanguage: originalLanguage,
      MoviesTable.overview: overview,
      MoviesTable.releaseDate: releaseDate,
      MoviesTable.posterPath: posterPath,
      MoviesTable.backdropPath: backdropPath,
      MoviesTable.popularity: popularity,
      MoviesTable.voteAverage: voteAverage,
      MoviesTable.voteCount: voteCount,
      MoviesTable.adult: adult ? 1 : 0,
      MoviesTable.video: video ? 1 : 0,
      BaseColumns.createdAt: createdAt.toIso8601String(),
      BaseColumns.updatedAt: updatedAt.toIso8601String(),
      BaseColumns.deletedAt: deletedAt?.toIso8601String(),
      BaseColumns.syncId: syncId,
      BaseColumns.syncStatus: syncStatus,
    };
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: map[MoviesTable.id] as String,
      title: map[MoviesTable.title] as String,
      originalTitle: map[MoviesTable.originalTitle] as String?,
      originalLanguage: map[MoviesTable.originalLanguage] as String?,
      overview: map[MoviesTable.overview] as String?,
      releaseDate: map[MoviesTable.releaseDate] as String?,
      posterPath: map[MoviesTable.posterPath] as String?,
      backdropPath: map[MoviesTable.backdropPath] as String?,
      popularity: (map[MoviesTable.popularity] as num?)?.toDouble() ?? 0,
      voteAverage: (map[MoviesTable.voteAverage] as num?)?.toDouble() ?? 0,
      voteCount: (map[MoviesTable.voteCount] as num?)?.toInt() ?? 0,
      adult: (map[MoviesTable.adult] as int? ?? 0) != 0,
      video: (map[MoviesTable.video] as int? ?? 0) != 0,
      createdAt: DateTime.parse(map[BaseColumns.createdAt] as String),
      updatedAt: DateTime.parse(map[BaseColumns.updatedAt] as String),
      deletedAt: map[BaseColumns.deletedAt] != null
          ? DateTime.parse(map[BaseColumns.deletedAt] as String)
          : null,
      syncId: map[BaseColumns.syncId] as String?,
      syncStatus: (map[BaseColumns.syncStatus] as num?)?.toInt() ?? 0,
    );
  }
}
