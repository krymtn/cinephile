import 'json_dto.dart';

/// Generic envelope for TMDB paginated list endpoints.
///
/// All TMDB list responses (`/movie/popular`, `/movie/now_playing`,
/// `/search/movie`, `/person/popular`, …) share the same shape:
///
/// ```
/// {
///   "page": 1,
///   "results": [ ...items ],
///   "total_pages": 42,
///   "total_results": 837,
///   "dates": { "minimum": "...", "maximum": "..." } // optional
/// }
/// ```
class PagedDto<T extends JsonDto> implements JsonDto {
  const PagedDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
    this.windowStart,
    this.windowEnd,
  });

  final int page;
  final List<T> results;
  final int totalPages;
  final int totalResults;

  /// Raw `YYYY-MM-DD` strings preserved from the optional `dates` envelope
  /// returned by `now_playing` / `upcoming`. Mappers parse them into
  /// `DateTime` for the domain layer.
  final String? windowStart;
  final String? windowEnd;

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((item) => item.toJson()).toList(growable: false),
      'total_pages': totalPages,
      'total_results': totalResults,
      if (windowStart != null || windowEnd != null)
        'dates': {
          if (windowStart != null) 'minimum': windowStart,
          if (windowEnd != null) 'maximum': windowEnd,
        },
    };
  }
}

/// Builds a [PagedDto] of [T] by delegating item parsing to [itemSerializer].
///
/// `const`-constructible so we can declare the per-resource page serializer as
/// a top-level constant:
///
/// ```dart
/// const pagedMoviesSerializer = PagedSerializer<MovieDto>(movieSerializer);
/// ```
class PagedSerializer<T extends JsonDto> implements Serializer<PagedDto<T>> {
  const PagedSerializer(this.itemSerializer);

  final Serializer<T> itemSerializer;

  @override
  PagedDto<T> fromJson(Map<String, dynamic> json) {
    final dates = json['dates'] as Map<String, dynamic>?;
    final rawResults = (json['results'] as List?) ?? const [];

    return PagedDto<T>(
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: rawResults
          .whereType<Map<String, dynamic>>()
          .map(itemSerializer.fromJson)
          .toList(growable: false),
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
      windowStart: dates?['minimum'] as String?,
      windowEnd: dates?['maximum'] as String?,
    );
  }
}
