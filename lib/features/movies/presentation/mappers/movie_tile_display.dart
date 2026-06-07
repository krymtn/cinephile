import '../../../../core/images/tmdb_images.dart';
import '../../../../core/presentation/widgets/cells/media_tile_display.dart';
import '../../domain/movie.dart';

/// Builds a [MediaTileDisplay] for a [Movie] shown in a horizontal carousel
/// (portrait poster, 2/3 aspect ratio).
MediaTileDisplay movieCarouselDisplay(Movie movie) {
  return MediaTileDisplay(
    id: movie.id,
    title: movie.title,
    badge: _scoreLabel(movie.voteAverage),
    imageUrl: TmdbImages.poster(movie.posterPath),
    artKind: MediaArtKind.poster,
    aspectRatio: 2 / 3,
    width: 132,
  );
}

String? _scoreLabel(double score) =>
    score > 0 ? score.toStringAsFixed(1) : null;
