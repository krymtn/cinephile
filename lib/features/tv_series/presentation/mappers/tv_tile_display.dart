import '../../../../core/images/tmdb_images.dart';
import '../../../../core/presentation/widgets/cells/media_row_display.dart';
import '../../../../core/presentation/widgets/cells/media_tile_display.dart';
import '../../domain/tv_series.dart';

/// Builds a [MediaTileDisplay] for a [TvSeries] shown in a horizontal carousel
/// (landscape backdrop, 16/9 aspect ratio).
///
/// Prefers [TvSeries.backdropPath]; falls back to [TvSeries.posterPath] when
/// no backdrop is available.
MediaTileDisplay tvCarouselDisplay(TvSeries series) {
  return MediaTileDisplay(
    id: series.id,
    title: series.title,
    badge: scoreLabel(series.voteAverage),
    imageUrl:
        TmdbImages.backdrop(series.backdropPath) ??
        TmdbImages.poster(series.posterPath),
    artKind: MediaArtKind.backdrop,
    aspectRatio: 16 / 9,
    width: 168,
  );
}

/// Builds a [MediaRowDisplay] for a [TvSeries] shown in a vertical catalog list.
MediaRowDisplay tvRowDisplay(TvSeries series) {
  return MediaRowDisplay(
    id: series.id,
    title: series.title,
    subtitle: _tvSubtitle(series),
    trailing: scoreLabel(series.voteAverage),
    imageUrl: TmdbImages.poster(series.posterPath, size: 'w185'),
    artKind: MediaArtKind.poster,
  );
}

String? scoreLabel(double score) => score > 0 ? score.toStringAsFixed(1) : null;

String _tvSubtitle(TvSeries series) {
  final year = series.firstAirYear;
  final countries = series.originCountries.where((c) => c.isNotEmpty).toList();
  final countryLabel = countries.isEmpty ? null : countries.join(', ');

  if (year == null && countryLabel == null) return '—';
  if (year != null && countryLabel != null) return '$year · $countryLabel';
  if (year != null) return '$year';
  return countryLabel!;
}
