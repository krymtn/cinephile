import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/tv_series_catalog_kind.dart';
import '../../../domain/use_cases/load_tv_series_catalog_page.dart';
import '../../../domain/use_cases/sync_tv_series_catalog_page.dart';
import '../../../domain/use_cases/tv_series_catalog_page_input.dart';
import 'catalog_state.dart';

class TvSeriesCatalogCubit extends Cubit<TvSeriesCatalogState> {
  TvSeriesCatalogCubit({
    required LoadTvSeriesCatalogPage loadTvSeriesCatalogPage,
    required SyncTvSeriesCatalogPage syncTvSeriesCatalogPage,
    TvSeriesCatalogKind initialKind = TvSeriesCatalogKind.airingToday,
  }) : _loadTvSeriesCatalogPage = loadTvSeriesCatalogPage,
       _syncTvSeriesCatalogPage = syncTvSeriesCatalogPage,
       super(TvSeriesCatalogInitial(selectedKind: initialKind));

  final LoadTvSeriesCatalogPage _loadTvSeriesCatalogPage;
  final SyncTvSeriesCatalogPage _syncTvSeriesCatalogPage;

  Future<void> selectKind(TvSeriesCatalogKind kind) => _load(kind);

  Future<void> loadInitial() => _load(state.selectedKind);

  Future<void> refresh() => _sync(state.selectedKind);

  Future<void> loadMore() async {
    final current = state;
    if (current is! TvSeriesCatalogLoaded) return;
    if (current.isLoadingMore) return;
    if (current.page >= current.totalPages) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.page + 1;
      final page = await _loadTvSeriesCatalogPage.invoke(
        TvSeriesCatalogPageInput(kind: current.selectedKind, page: nextPage),
      );
      emit(
        current.copyWith(
          series: [...current.series, ...page.series],
          page: page.page,
          totalPages: page.totalPages,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _load(TvSeriesCatalogKind kind) async {
    emit(TvSeriesCatalogLoading(selectedKind: kind));
    try {
      final page = await _loadTvSeriesCatalogPage.invoke(
        TvSeriesCatalogPageInput(kind: kind, page: 1),
      );
      emit(
        TvSeriesCatalogLoaded(
          selectedKind: kind,
          series: page.series,
          page: page.page,
          totalPages: page.totalPages,
        ),
      );
    } catch (e, st) {
      emit(
        TvSeriesCatalogFailure(selectedKind: kind, error: e, stackTrace: st),
      );
    }
  }

  Future<void> _sync(TvSeriesCatalogKind kind) async {
    emit(TvSeriesCatalogLoading(selectedKind: kind));
    try {
      final page = await _syncTvSeriesCatalogPage.invoke(
        TvSeriesCatalogPageInput(kind: kind, page: 1),
      );
      emit(
        TvSeriesCatalogLoaded(
          selectedKind: kind,
          series: page.series,
          page: page.page,
          totalPages: page.totalPages,
        ),
      );
    } catch (e, st) {
      emit(
        TvSeriesCatalogFailure(selectedKind: kind, error: e, stackTrace: st),
      );
    }
  }
}
