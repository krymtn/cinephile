import '../../../../core/data/json_dto.dart';
import '../../../../core/data/media_list_dto.dart';
import '../../../../core/data/paged_dto.dart';

/// Wire-format representation of a TV show row from TMDB list endpoints
/// (e.g. `/tv/popular`, `/tv/{id}`).
///
/// Shared list keys live on [MediaListDto]; TV-only keys (`name`, `first_air_date`,
/// `origin_country`) stay here. Domain mapping uses [Media.title] for display
/// (`name` on the wire).
///
/// Deserialization lives in [TvSeriesSerializer] ([tvSeriesSerializer]), not in
/// a `factory TvSeriesDto.fromJson` on this class.
class TvSeriesDto extends MediaListDto implements JsonDto {
  const TvSeriesDto({
    required super.id,
    required this.name,
    this.originalName,
    super.originalLanguage,
    super.overview,
    this.firstAirDate,
    super.posterPath,
    super.backdropPath,
    super.genreIds = const [],
    super.popularity = 0,
    super.voteAverage = 0,
    super.voteCount = 0,
    this.originCountry = const [],
  });

  /// TMDB `name` (display title on list rows).
  final String name;

  /// TMDB `original_name`.
  final String? originalName;

  /// Raw `YYYY-MM-DD` from `first_air_date`; mapper turns empty strings into `null`.
  final String? firstAirDate;

  /// TMDB `origin_country` (ISO region codes).
  final List<String> originCountry;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...mediaListFieldsToJson(),
      'name': name,
      'original_name': originalName,
      'first_air_date': firstAirDate,
      'origin_country': originCountry,
    };
  }
}

/// Companion serializer for [TvSeriesDto].
class TvSeriesSerializer implements Serializer<TvSeriesDto> {
  const TvSeriesSerializer();

  @override
  TvSeriesDto fromJson(Map<String, dynamic> json) {
    final shared = parseMediaListJson(json);
    return TvSeriesDto(
      id: shared.id,
      name: json['name'] as String,
      originalName: json['original_name'] as String?,
      originalLanguage: shared.originalLanguage,
      overview: shared.overview,
      firstAirDate: json['first_air_date'] as String?,
      posterPath: shared.posterPath,
      backdropPath: shared.backdropPath,
      genreIds: shared.genreIds,
      popularity: shared.popularity,
      voteAverage: shared.voteAverage,
      voteCount: shared.voteCount,
      originCountry:
          (json['origin_country'] as List?)?.whereType<String>().toList() ??
          const [],
    );
  }
}

const tvSeriesSerializer = TvSeriesSerializer();

/// Page serializer for `/tv/{airing_today,on_the_air,popular,top_rated}`.
const pagedTvSeriesSerializer = PagedSerializer<TvSeriesDto>(tvSeriesSerializer);
