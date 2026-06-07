/// TMDB image base URL and size helpers.
///
/// TMDB paths (e.g. `/abc123.jpg`) are relative; this helper composes full
/// URLs for use in display models and network image widgets.
abstract final class TmdbImages {
  static const String _base = 'https://image.tmdb.org/t/p';

  /// Standard poster sizes: w92, w154, w185, w342, w500, w780, original.
  static String? poster(String? path, {String size = 'w342'}) {
    if (path == null || path.isEmpty) return null;
    return '$_base/$size$path';
  }

  /// Standard backdrop sizes: w300, w780, w1280, original.
  static String? backdrop(String? path, {String size = 'w780'}) {
    if (path == null || path.isEmpty) return null;
    return '$_base/$size$path';
  }
}
