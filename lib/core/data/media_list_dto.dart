/// Wire-level fields whose TMDB JSON keys are identical on movie and TV list
/// items (`/movie/*`, `/tv/*`). Subtypes add resource-specific keys (`title`
/// vs `name`, `release_date` vs `first_air_date`, etc.).
abstract class MediaListDto {
  const MediaListDto({
    required this.id,
    this.originalLanguage,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.genreIds = const [],
    this.popularity = 0,
    this.voteAverage = 0,
    this.voteCount = 0,
  });

  final int id;
  final String? originalLanguage;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  /// Subset of JSON shared with TV list serializers.
  Map<String, dynamic> mediaListFieldsToJson() {
    return {
      'id': id,
      'original_language': originalLanguage,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'popularity': popularity,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}

/// Parsed block reused by per-resource serializers (movies, TV, …).
final class ParsedMediaListJson {
  const ParsedMediaListJson({
    required this.id,
    this.originalLanguage,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.genreIds = const [],
    this.popularity = 0,
    this.voteAverage = 0,
    this.voteCount = 0,
  });

  final int id;
  final String? originalLanguage;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;
}

ParsedMediaListJson parseMediaListJson(Map<String, dynamic> json) {
  return ParsedMediaListJson(
    id: json['id'] as int,
    originalLanguage: json['original_language'] as String?,
    overview: json['overview'] as String?,
    posterPath: json['poster_path'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    genreIds:
        (json['genre_ids'] as List?)?.whereType<int>().toList() ?? const [],
    popularity: _jsonDouble(json['popularity']),
    voteAverage: _jsonDouble(json['vote_average']),
    voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
  );
}

double _jsonDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return 0;
}
