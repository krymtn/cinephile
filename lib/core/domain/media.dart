import 'media_kind.dart';

/// Shared TMDB list-row fields for movies and TV. Subtypes add kind-specific
/// data ([Movie]: `adult`, `video`, credits; TV: `originCountry`, etc.).
abstract class Media {
  const Media({
    required this.kind,
    required this.id,
    required this.title,
    this.originalTitle,
    this.originalLanguage,
    this.overview,
    this.primaryDate,
    this.posterPath,
    this.backdropPath,
    this.genreIds = const [],
    this.popularity = 0,
    this.voteAverage = 0,
    this.voteCount = 0,
  });

  final MediaKind kind;
  final int id;
  final String title;
  final String? originalTitle;
  final String? originalLanguage;
  final String? overview;

  /// Theatrical / streaming premiere for movies, first broadcast for TV.
  final DateTime? primaryDate;

  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  final double popularity;
  final double voteAverage;
  final int voteCount;

  int? get primaryYear => primaryDate?.year;
}
