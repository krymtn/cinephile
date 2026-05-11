/// Columns that mirror the overlap between [Media] and cached TMDB list rows.
///
/// [MovieEntity] implements this today; a future `TvShowEntity` can do the
/// same so DAOs or mappers can treat both shapes uniformly where needed.
abstract interface class MediaListEntityPayload {
  String get title;
  String? get originalTitle;
  String? get originalLanguage;
  String? get overview;
  String? get posterPath;
  String? get backdropPath;
  double get popularity;
  double get voteAverage;
  int get voteCount;

  /// `release_date` for movies, `first_air_date` for TV (raw DB string).
  String? get primaryDateRaw;
}
