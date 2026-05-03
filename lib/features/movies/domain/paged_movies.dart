import 'movie.dart';

/// One page from a paginated movie list API (e.g. now playing, popular).
class PagedMovies {
  const PagedMovies({
    required this.movies,
    required this.page,
    required this.totalPages,
    required this.totalResults,
    this.windowStart,
    this.windowEnd,
  });

  final List<Movie> movies;
  final int page;
  final int totalPages;
  final int totalResults;

  /// Theater/date window when the API returns it (e.g. now playing).
  final DateTime? windowStart;
  final DateTime? windowEnd;
}
