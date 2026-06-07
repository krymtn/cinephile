import '../../../../core/images/tmdb_images.dart';
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
    badge: _scoreLabel(series.voteAverage),
    imageUrl: TmdbImages.backdrop(series.backdropPath) ??
        TmdbImages.poster(series.posterPath),
    artKind: MediaArtKind.backdrop,
    aspectRatio: 16 / 9,
    width: 168,
  );
}

String? _scoreLabel(double score) =>
    score > 0 ? score.toStringAsFixed(1) : null;
