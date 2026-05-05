
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
    this.video = false
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

  @override
  Map<String, dynamic> toMap() {
    return {
      MovieSchema.id: id,
      MovieSchema.title: title,
      MovieSchema.originalTitle: originalTitle,
      MovieSchema.originalLanguage: originalLanguage,
      MovieSchema.overview: overview,
      MovieSchema.releaseDate: releaseDate,
      MovieSchema.posterPath: posterPath,
      MovieSchema.backdropPath: backdropPath,
      MovieSchema.popularity: popularity,
      MovieSchema.voteAverage: voteAverage,
      MovieSchema.voteCount: voteCount,
      MovieSchema.adult: adult ? 1 : 0,
      MovieSchema.video: video ? 1 : 0,
    };
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: map[MovieSchema.id] as String,
      title: map[MovieSchema.title] as String,
      originalTitle: map[MovieSchema.originalTitle] as String?,
      originalLanguage: map[MovieSchema.originalLanguage] as String?,
      overview: map[MovieSchema.overview] as String?,
      releaseDate: map[MovieSchema.releaseDate] as String?,
      posterPath: map[MovieSchema.posterPath] as String?,
      backdropPath: map[MovieSchema.backdropPath] as String?,
      popularity: (map[MovieSchema.popularity] as num?)?.toDouble() ?? 0,
      voteAverage: (map[MovieSchema.voteAverage] as num?)?.toDouble() ?? 0,
      voteCount: (map[MovieSchema.voteCount] as num?)?.toInt() ?? 0,
      adult: (map[MovieSchema.adult] as int? ?? 0) != 0,
      video: (map[MovieSchema.video] as int? ?? 0) != 0
    );
  }
}
