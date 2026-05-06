import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../../../core/data/paged_dto.dart';
import '../../domain/movie_catalog_kind.dart';
import '../dto/movie_dto.dart';
import 'data_source.dart';

/// Fixture-backed [MovieRemoteDataSource] that loads JSON files shipped under
/// `assets/mocks/movies/`.
///
/// Useful for:
/// - Bringing the UI up before a TMDB token is wired in.
/// - Running the app fully offline against deterministic data.
/// - Unit-testing the DTO/mapper pipeline against snapshots of real responses.
///
/// Each [MovieCatalogKind] maps to one JSON file. The fixtures intentionally
/// expose the `dates` envelope for `now_playing` and `upcoming` only,
/// matching real TMDB behaviour.
///
/// Pagination: the bundled fixtures only cover page 1. Requests for `page > 1`
/// return an empty `results` list with the same `totalPages`/`totalResults`
/// as page 1, so list UIs still terminate cleanly without a special-case.
class MockMovieRemoteDataSource implements MovieRemoteDataSource {
  MockMovieRemoteDataSource({
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 300),
  }) : _bundle = bundle ?? rootBundle;

  /// Bundle to read fixtures from. Defaults to [rootBundle]; tests can pass
  /// an in-memory bundle to avoid asset registration.
  final AssetBundle _bundle;

  /// Simulated network delay applied to every call. Set to [Duration.zero]
  /// in tests for deterministic timing.
  final Duration latency;

  @override
  Future<PagedDto<MovieDto>> fetchCatalog(
    MovieCatalogKind kind, {
    int page = 1,
    String? language,
    String? region,
  }) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }

    final raw = await _bundle.loadString(_assetPath(kind));
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final dto = pagedMoviesSerializer.fromJson(json);

    if (page <= 1) return dto;

    return PagedDto<MovieDto>(
      page: page,
      results: const [],
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
      windowStart: dto.windowStart,
      windowEnd: dto.windowEnd,
    );
  }

  String _assetPath(MovieCatalogKind kind) =>
      'assets/mocks/movies/${kind.wireKey}.json';
}
