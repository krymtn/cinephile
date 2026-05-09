import '../../../../core/data/json_dto.dart';
import '../../../../core/data/media_list_dto.dart';
import '../../../../core/data/paged_dto.dart';

/// Wire-format representation of a single movie returned by TMDB list and
/// detail endpoints (e.g. `/movie/popular`, `/movie/{id}`).
///
/// Shared list keys live on [MediaListDto]; movie-only keys stay here.
///
/// Stays close to the JSON: snake_case keys, raw date strings. Conversion to
/// the domain [Movie] (with parsed [DateTime]s and stricter null handling)
/// happens in the mappers layer, not here.
///
/// Deserialization lives in [MovieSerializer] (use the [movieSerializer]
/// constant), **not** in a `factory MovieDto.fromJson` on this class.
class MovieDto extends MediaListDto implements JsonDto {
  const MovieDto({
    required super.id,
    required this.title,
    this.originalTitle,
    super.originalLanguage,
    super.overview,
    this.releaseDate,
    super.posterPath,
    super.backdropPath,
    super.genreIds = const [],
    super.popularity = 0,
    super.voteAverage = 0,
    super.voteCount = 0,
    this.adult = false,
    this.video = false,
  });

  final String title;
  final String? originalTitle;

  /// Raw `YYYY-MM-DD` string from TMDB. Empty strings appear for unscheduled
  /// releases — preserved as-is here; the mapper turns them into `null`.
  final String? releaseDate;

  final bool adult;
  final bool video;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...mediaListFieldsToJson(),
      'title': title,
      'original_title': originalTitle,
      'release_date': releaseDate,
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
    final shared = parseMediaListJson(json);
    return MovieDto(
      id: shared.id,
      title: json['title'] as String,
      originalTitle: json['original_title'] as String?,
      originalLanguage: shared.originalLanguage,
      overview: shared.overview,
      releaseDate: json['release_date'] as String?,
      posterPath: shared.posterPath,
      backdropPath: shared.backdropPath,
      genreIds: shared.genreIds,
      popularity: shared.popularity,
      voteAverage: shared.voteAverage,
      voteCount: shared.voteCount,
      adult: json['adult'] as bool? ?? false,
      video: json['video'] as bool? ?? false,
    );
  }
}

/// Singleton serializer instance for [MovieDto]. Prefer this over constructing
/// a fresh `MovieSerializer()` at every call site.
const movieSerializer = MovieSerializer();

/// Page envelope serializer for `/movie/{now_playing,popular,top_rated,upcoming}`
/// and any other paginated endpoint that returns a list of movies.
const pagedMoviesSerializer = PagedSerializer<MovieDto>(movieSerializer);
