import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/tv_series_catalog_kind.dart';
import '../../domain/use_cases/use_cases.dart';
import '../cubits/cubits.dart';
import '../tv_home_sections.dart';
import '../widgets/padding/tv_series_cell.dart';

class TvSeriesCatalogListPage extends StatelessWidget {
  const TvSeriesCatalogListPage({super.key, required this.kind, this.title});

  final TvSeriesCatalogKind kind;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TvSeriesCatalogCubit(
        loadTvSeriesCatalogPage: context.read<LoadTvSeriesCatalogPage>(),
        syncTvSeriesCatalogPage: context.read<SyncTvSeriesCatalogPage>(),
        initialKind: kind,
      )..loadInitial(),
      child: _TvSeriesCatalogListScaffold(title: title ?? tvSectionTitle(kind)),
    );
  }
}

class _TvSeriesCatalogListScaffold extends StatefulWidget {
  const _TvSeriesCatalogListScaffold({required this.title});

  final String title;

  @override
  State<_TvSeriesCatalogListScaffold> createState() =>
      _TvSeriesCatalogListScaffoldState();
}

class _TvSeriesCatalogListScaffoldState
    extends State<_TvSeriesCatalogListScaffold> {
  late final ScrollController _controller = ScrollController()
    ..addListener(_onScroll);

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.maxScrollExtent == 0) return;

    if (position.pixels >= position.maxScrollExtent - 320) {
      context.read<TvSeriesCatalogCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<TvSeriesCatalogCubit>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<TvSeriesCatalogCubit, TvSeriesCatalogState>(
        builder: (context, state) {
          return switch (state) {
            TvSeriesCatalogLoaded(:final series, :final isLoadingMore) =>
              ListView.separated(
                controller: _controller,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                itemCount: series.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= series.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return TvSeriesCell(series: series[index]);
                },
              ),
            TvSeriesCatalogFailure() => ListView(
              controller: _controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: const [
                TvSeriesCellSkeleton(),
                SizedBox(height: 12),
                TvSeriesCellSkeleton(),
                SizedBox(height: 12),
                TvSeriesCellSkeleton(),
              ],
            ),
            _ => ListView(
              controller: _controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: const [
                TvSeriesCellSkeleton(),
                SizedBox(height: 12),
                TvSeriesCellSkeleton(),
                SizedBox(height: 12),
                TvSeriesCellSkeleton(),
                SizedBox(height: 12),
                TvSeriesCellSkeleton(),
                SizedBox(height: 12),
                TvSeriesCellSkeleton(),
              ],
            ),
          };
        },
      ),
    );
  }
}
