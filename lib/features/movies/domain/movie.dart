/// Movie as used by the app (summary rows, carousels). Mirrors list API fields;
/// enrich with [directorName] when details/credits are loaded.
class Movie {
  const Movie({
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
    this.directorName,
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? originalLanguage;
  final String? overview;
  final DateTime? releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final bool video;

  /// Not present on list endpoints; optional until filled from credits/details.
  final String? directorName;

  int? get releaseYear => releaseDate?.year;
}
