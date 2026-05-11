/// TMDB namespaces numeric IDs separately for movies vs TV; carry [MediaKind]
/// anywhere a bare [id] would be ambiguous.
enum MediaKind { movie, tv }
