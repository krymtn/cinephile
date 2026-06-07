import '../../../../core/images/tmdb_images.dart';
import '../../../../core/presentation/widgets/cells/media_row_display.dart';
import '../../../../core/presentation/widgets/cells/media_tile_display.dart';
import '../../domain/movie.dart';

/// Builds a [MediaTileDisplay] for a [Movie] shown in a horizontal carousel
/// (portrait poster, 2/3 aspect ratio).
MediaTileDisplay movieCarouselDisplay(Movie movie) {
  return MediaTileDisplay(
    id: movie.id,
    title: movie.title,
    badge: scoreLabel(movie.voteAverage),
    imageUrl: TmdbImages.poster(movie.posterPath),
    artKind: MediaArtKind.poster,
    aspectRatio: 2 / 3,
    width: 132,
  );
}

/// Builds a [MediaRowDisplay] for a [Movie] shown in a vertical catalog list.
MediaRowDisplay movieRowDisplay(Movie movie) {
  return MediaRowDisplay(
    id: movie.id,
    title: movie.title,
    subtitle: _movieSubtitle(movie),
    trailing: scoreLabel(movie.voteAverage),
    imageUrl: TmdbImages.poster(movie.posterPath, size: 'w185'),
    artKind: MediaArtKind.poster,
  );
}

String? scoreLabel(double score) =>
    score > 0 ? score.toStringAsFixed(1) : null;

String _movieSubtitle(Movie movie) {
  final year = movie.releaseYear;
  final director = movie.directorName;
  if (year == null && (director == null || director.isEmpty)) {
    return '—';
  }
  if (year != null && director != null && director.isNotEmpty) {
    return '$year · $director';
  }
  if (year != null) return '$year';
  return director!;
}
