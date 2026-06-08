import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_client.dart';
import '../data/remote/data_source.dart';
import '../data/remote/http_data_source.dart';
import '../data/repositories/tv_series_repository_impl.dart';
import '../domain/tv_series_repository.dart';
import '../domain/use_cases/use_cases.dart';

/// Provides every TV-series-feature dependency (data sources, repository,
/// use-cases) to its [child] subtree.
///
/// Place this above the navigator that hosts TV routes so all pushed pages
/// inherit the same provider scope. Relies on [NetworkClient] being available
/// higher up (provided in `main.dart`).
class TvSeriesProviders extends StatelessWidget {
  const TvSeriesProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final networkClient = context.read<NetworkClient>();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TvSeriesRemoteDataSource>(
          create: (_) => HttpTvSeriesRemoteDataSource(networkClient),
        ),
        RepositoryProvider<TvSeriesRepository>(
          create: (context) => TvSeriesRepositoryImpl(
            remoteDataSource: context.read<TvSeriesRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<LoadTvSeriesCatalogPage>(
          create: (context) =>
              LoadTvSeriesCatalogPage(context.read<TvSeriesRepository>()),
        ),
        RepositoryProvider<SyncTvSeriesCatalogPage>(
          create: (context) =>
              SyncTvSeriesCatalogPage(context.read<TvSeriesRepository>()),
        ),
      ],
      child: child,
    );
  }
}
