import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../../../core/data/paged_dto.dart';
import '../../domain/tv_series_catalog_kind.dart';
import '../dto/tv_series_dto.dart';
import 'data_source.dart';

/// Fixture-backed [TvSeriesRemoteDataSource] reading `assets/mocks/tv_series/`.
///
/// Each [TvSeriesCatalogKind] maps to `${wireKey}.json`. Pagination matches
/// [MockMovieRemoteDataSource]: page 1 uses the fixture; `page > 1` returns
/// empty `results` with the same totals.
class MockTvSeriesRemoteDataSource implements TvSeriesRemoteDataSource {
  MockTvSeriesRemoteDataSource({
    AssetBundle? bundle,
    this.latency = const Duration(milliseconds: 300),
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Duration latency;

  @override
  Future<PagedDto<TvSeriesDto>> fetchCatalog(
    TvSeriesCatalogKind kind, {
    int page = 1,
    String? language,
    String? region,
  }) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }

    final raw = await _bundle.loadString(_assetPath(kind));
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final dto = pagedTvSeriesSerializer.fromJson(json);

    if (page <= 1) return dto;

    return PagedDto<TvSeriesDto>(
      page: page,
      results: const [],
      totalPages: dto.totalPages,
      totalResults: dto.totalResults,
      windowStart: dto.windowStart,
      windowEnd: dto.windowEnd,
    );
  }

  String _assetPath(TvSeriesCatalogKind kind) =>
      'assets/mocks/tv_series/${kind.wireKey}.json';
}
