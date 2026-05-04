/// Common contract for hand-rolled JSON DTOs (no codegen).
///
/// `JsonDto` forces every DTO to expose a [toJson]. The deserialization
/// logic is enforced by the companion [Serializer] interface.
///
/// Together they give a fully type-checked round-trip:
///
/// ```dart
/// class MovieDto implements JsonDto {
///   const MovieDto({required this.id, required this.title});
///
///   final int id;
///   final String title;
///
///   @override
///   Map<String, dynamic> toJson() => {'id': id, 'title': title};
/// }
///
/// class MovieSerializer implements Serializer<MovieDto> {
///   const MovieSerializer();
///
///   @override
///   MovieDto fromJson(Map<String, dynamic> json) => MovieDto(
///         id: json['id'] as int,
///         title: json['title'] as String,
///       );
/// }
///
/// const movieSerializer = MovieSerializer();
/// ```
abstract interface class JsonDto {
  /// Serializes this DTO to a JSON-ready map. Must be the exact inverse of
  /// the matching [Serializer.fromJson].
  Map<String, dynamic> toJson();
}

/// A separate interface for the "creation" logic.
///
/// Implementations are typically `const`-constructible and exposed as a
/// top-level `const` instance (`const movieSerializer = MovieSerializer();`)
/// so they're cheap to pass around.
abstract interface class Serializer<T extends JsonDto> {
  /// Inverse of [JsonDto.toJson] for type [T].
  T fromJson(Map<String, dynamic> json);
}
