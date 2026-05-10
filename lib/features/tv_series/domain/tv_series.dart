import '../../../core/domain/media.dart';
import '../../../core/domain/media_kind.dart';

/// TV show as used by the app (summary rows, carousels). List API uses `name`
/// and `first_air_date`; those map to [title] and [primaryDate] on [Media].
class TvSeries extends Media {
  const TvSeries({
    required super.id,
    required super.title,
    super.originalTitle,
    super.originalLanguage,
    super.overview,
    DateTime? firstAirDate,
    super.posterPath,
    super.backdropPath,
    super.genreIds = const [],
    super.popularity = 0,
    super.voteAverage = 0,
    super.voteCount = 0,
    this.originCountries = const [],
  }) : super(kind: MediaKind.tv, primaryDate: firstAirDate);

  /// Same as [primaryDate] (TMDB `first_air_date`).
  DateTime? get firstAirDate => primaryDate;

  /// TMDB `origin_country` (ISO 3166-1 codes, typically two letters).
  final List<String> originCountries;

  int? get firstAirYear => firstAirDate?.year;
}
