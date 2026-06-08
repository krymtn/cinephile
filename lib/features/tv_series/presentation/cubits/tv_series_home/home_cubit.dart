import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/paged_tv_series.dart';
import '../../../domain/tv_series_catalog_kind.dart';
import '../../../domain/use_cases/load_tv_series_catalog_page.dart';
import '../../../domain/use_cases/sync_tv_series_catalog_page.dart';
import '../../../domain/use_cases/tv_series_catalog_page_input.dart';
import '../../tv_home_sections.dart';
import 'home_state.dart';

class TvSeriesHomeCubit extends Cubit<TvSeriesHomeState> {
  TvSeriesHomeCubit({
    required LoadTvSeriesCatalogPage loadTvSeriesCatalogPage,
    required SyncTvSeriesCatalogPage syncTvSeriesCatalogPage,
  }) : _loadTvSeriesCatalogPage = loadTvSeriesCatalogPage,
       _syncTvSeriesCatalogPage = syncTvSeriesCatalogPage,
       super(TvSeriesHomeState.initial());

  final LoadTvSeriesCatalogPage _loadTvSeriesCatalogPage;
  final SyncTvSeriesCatalogPage _syncTvSeriesCatalogPage;

  int _loadGeneration = 0;

  Future<void> loadInitial() =>
      _loadSectionsInParallel(_loadTvSeriesCatalogPage.invoke);

  Future<void> refresh() =>
      _loadSectionsInParallel(_syncTvSeriesCatalogPage.invoke);

  Future<void> _loadSectionsInParallel(
    Future<PagedTvSeries> Function(TvSeriesCatalogPageInput input) fetch,
  ) async {
    final generation = ++_loadGeneration;
    emit(TvSeriesHomeState.loading());

    await Future.wait(
      tvHomeSectionKinds.map(
        (kind) => _loadOneSection(kind, fetch, generation),
      ),
    );
  }

  Future<void> _loadOneSection(
    TvSeriesCatalogKind kind,
    Future<PagedTvSeries> Function(TvSeriesCatalogPageInput input) fetch,
    int generation,
  ) async {
    try {
      final page = await fetch(TvSeriesCatalogPageInput(kind: kind, page: 1));
      if (generation != _loadGeneration || isClosed) return;

      emit(state.copyWithSection(kind, TvSectionLoaded(page.series)));
    } catch (e, st) {
      if (generation != _loadGeneration || isClosed) return;

      emit(state.copyWithSection(kind, TvSectionFailure(e, stackTrace: st)));
    }
  }
}
