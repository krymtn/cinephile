import '../../../../core/data/paged_dto.dart';
import '../../domain/paged_tv_series.dart';
import '../../domain/tv_series.dart';
import '../dto/tv_series_dto.dart';

/// Extension to map [TvSeriesDto] to domain models.
extension TvSeriesDtoMapper on TvSeriesDto {
  TvSeries toDomain() {
    return TvSeries(
      id: id,
      title: name,
      originalTitle: originalName,
      originalLanguage: originalLanguage,
      overview: overview,
      firstAirDate: firstAirDate != null && firstAirDate!.isNotEmpty
          ? DateTime.tryParse(firstAirDate!)
          : null,
      posterPath: posterPath,
      backdropPath: backdropPath,
      genreIds: genreIds,
      popularity: popularity,
      voteAverage: voteAverage,
      voteCount: voteCount,
      originCountries: originCountry,
    );
  }
}

/// Extension to map [PagedDto] of [TvSeriesDto] to [PagedTvSeries].
extension PagedTvSeriesDtoMapper on PagedDto<TvSeriesDto> {
  PagedTvSeries toDomain() {
    return PagedTvSeries(
      series: results.map((dto) => dto.toDomain()).toList(),
      page: page,
      totalPages: totalPages,
      totalResults: totalResults,
      windowStart: windowStart != null && windowStart!.isNotEmpty
          ? DateTime.tryParse(windowStart!)
          : null,
      windowEnd: windowEnd != null && windowEnd!.isNotEmpty
          ? DateTime.tryParse(windowEnd!)
          : null,
    );
  }
}
