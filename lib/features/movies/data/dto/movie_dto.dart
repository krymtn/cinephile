import '../../../../core/data/json_dto.dart';
import '../../../../core/data/paged_dto.dart';

/// Wire-format representation of a single movie returned by TMDB list and
/// detail endpoints (e.g. `/movie/popular`, `/movie/{id}`).
///
/// Stays close to the JSON: snake_case keys, raw date strings. Conversion to
/// the domain `Movie` (with parsed [DateTime]s and stricter null handling)
/// happens in the mappers layer, not here.
///
/// Deserialization lives in [MovieSerializer] (use the [movieSerializer]
/// constant), **not** in a `factory MovieDto.fromJson` on this class.
class MovieDto implements JsonDto {
  const MovieDto({
    required this.id,
    required this.title,
    this.originalTitle,
    this.originalLanguage,
    this.overview,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    this.genreIds = const [],
    this.popularity = 0,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.adult = false,
    this.video = false,
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? originalLanguage;
  final String? overview;

  /// Raw `YYYY-MM-DD` string from TMDB. Empty strings appear for unscheduled
  /// releases — preserved as-is here; the mapper turns them into `null`.
  final String? releaseDate;

  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final bool video;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'original_language': originalLanguage,
      'overview': overview,
      'release_date': releaseDate,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds,
      'popularity': popularity,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'adult': adult,
      'video': video,
    };
  }
}

/// Companion serializer for [MovieDto]. Use [movieSerializer] in normal code.
class MovieSerializer implements Serializer<MovieDto> {
  const MovieSerializer();

  @override
  MovieDto fromJson(Map<String, dynamic> json) {
    return MovieDto(
      id: json['id'] as int,
      title: json['title'] as String,
      originalTitle: json['original_title'] as String?,
      originalLanguage: json['original_language'] as String?,
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      genreIds:
          (json['genre_ids'] as List?)?.whereType<int>().toList() ?? const [],
      popularity: _toDouble(json['popularity']),
      voteAverage: _toDouble(json['vote_average']),
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      adult: json['adult'] as bool? ?? false,
      video: json['video'] as bool? ?? false,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return 0;
  }
}

/// Singleton serializer instance for [MovieDto]. Prefer this over constructing
/// a fresh `MovieSerializer()` at every call site.
const movieSerializer = MovieSerializer();

/// Page envelope serializer for `/movie/{now_playing,popular,top_rated,upcoming}`
/// and any other paginated endpoint that returns a list of movies.
const pagedMoviesSerializer = PagedSerializer<MovieDto>(movieSerializer);
