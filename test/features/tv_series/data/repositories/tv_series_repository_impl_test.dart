import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:cinephileapp/features/tv_series/domain/tv_series_catalog_kind.dart';

import '../remote/mock_support.dart';

void main() {
  ensureTvSeriesMockAssetsBinding();

  late TvSeriesRepositoryImpl repository;

  setUp(() {
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: createMockTvSeriesRemoteDataSource(),
    );
  });

  group('TvSeriesRepositoryImpl', () {
    test('fetchCatalog maps DTO page to domain', () async {
      final page = await repository.fetchCatalog(TvSeriesCatalogKind.popular);

      expect(page.page, 1);
      expect(page.series, isNotEmpty);
      expect(page.series.first.title, isNotEmpty);
      expect(page.series.first.firstAirDate, isNotNull);
    });

    test('loadCatalog and syncCatalog return the same mapped page', () async {
      final loaded = await repository.loadCatalog(TvSeriesCatalogKind.topRated);
      final synced = await repository.syncCatalog(TvSeriesCatalogKind.topRated);

      expect(loaded.page, synced.page);
      expect(loaded.series.first.id, synced.series.first.id);
      expect(loaded.series.first.title, synced.series.first.title);
    });
  });
}
