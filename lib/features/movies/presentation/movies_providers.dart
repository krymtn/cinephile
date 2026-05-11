import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/network/network_client.dart';
import '../data/local/catalog_meta/dao.dart';
import '../data/local/catalog_page/dao.dart';
import '../data/local/data_source.dart';
import '../data/local/genre/dao.dart';
import '../data/local/movie/dao.dart';
import '../data/remote/data_source.dart';
import '../data/remote/http_data_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/movie_repository.dart';
import '../domain/use_cases/use_cases.dart';

/// Provides every movies-feature dependency (data sources, repository,
/// use-cases) to its [child] subtree.
///
/// Place this above the navigator that hosts movies routes so all pushed
/// pages inherit the same provider scope. Relies on [Database] and
/// [NetworkClient] being available higher up (provided in `main.dart`).
class MoviesProviders extends StatelessWidget {
  const MoviesProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final database = context.read<Database>();
    final networkClient = context.read<NetworkClient>();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieLocalDataSource>(
          create: (_) => MovieLocalDataSourceImpl(
            movieDao: MovieDao(database),
            genreDao: MovieGenreDao(database),
            catalogPageDao: MovieCatalogPageDao(database),
            catalogMetaDao: MovieCatalogMetaDao(database),
          ),
        ),
        RepositoryProvider<MovieRemoteDataSource>(
          create: (_) => HttpMovieRemoteDataSource(networkClient),
        ),
        RepositoryProvider<MovieRepository>(
          create: (context) => MovieRepositoryImpl(
            localDataSource: context.read<MovieLocalDataSource>(),
            remoteDataSource: context.read<MovieRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<LoadMovieCatalogPage>(
          create: (context) =>
              LoadMovieCatalogPage(context.read<MovieRepository>()),
        ),
        RepositoryProvider<SyncMovieCatalogPage>(
          create: (context) =>
              SyncMovieCatalogPage(context.read<MovieRepository>()),
        ),
      ],
      child: child,
    );
  }
}
