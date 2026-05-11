import '../../../core/domain/media.dart';
import '../../../core/domain/media_kind.dart';

/// Movie as used by the app (summary rows, carousels). Mirrors list API fields;
/// enrich with [directorName] when details/credits are loaded.
class Movie extends Media {
  const Movie({
    required super.id,
    required super.title,
    super.originalTitle,
    super.originalLanguage,
    super.overview,
    DateTime? releaseDate,
    super.posterPath,
    super.backdropPath,
    super.genreIds = const [],
    super.popularity = 0,
    super.voteAverage = 0,
    super.voteCount = 0,
    this.adult = false,
    this.video = false,
    this.directorName,
  }) : super(kind: MediaKind.movie, primaryDate: releaseDate);

  /// Same as [primaryDate] (TMDB `release_date`).
  DateTime? get releaseDate => primaryDate;

  final bool adult;
  final bool video;

  /// Not present on list endpoints; optional until filled from credits/details.
  final String? directorName;

  int? get releaseYear => releaseDate?.year;
}
