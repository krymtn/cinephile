import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sqflite/sqflite.dart';

import 'core/config/env_config.dart';
import 'core/database/database_manager.dart';
import 'core/extensions/build_context.dart';
import 'core/locale/locale_cubit.dart';
import 'core/locale/preferences_locale_repository.dart';
import 'core/locale/use_cases/load_app_locale.dart';
import 'core/locale/use_cases/set_app_locale.dart';
import 'core/network/network_client.dart';
import 'core/preferences/preferences.dart';
import 'core/preferences/secure_preference_store.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_repository.dart';
import 'core/theme/use_cases/load_app_theme_mode.dart';
import 'core/theme/use_cases/set_app_theme_mode.dart';
import 'features/movies/data/local/catalog_meta/schema.dart';
import 'features/movies/data/local/catalog_page/schema.dart';
import 'features/movies/data/local/genre/schema.dart';
import 'features/movies/data/local/movie/schema.dart';
import 'features/root/presentation/pages/root_shell_page.dart';
import 'l10n/generated/app_localizations.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DatabaseManager();
  db.registerDao(MovieSchema());
  db.registerDao(MovieGenreSchema());
  db.registerDao(MovieCatalogPageSchema());
  db.registerDao(MovieCatalogMetaSchema());

  final secureStore = SecurePreferenceStore(const FlutterSecureStorage());
  final preferences = Preferences(secureStore);

  final localeRepository = PreferencesLocaleRepository(preferences);
  final loadAppLocale = LoadAppLocale(localeRepository);
  final setAppLocale = SetAppLocale(localeRepository);
  final initialLocale = await loadAppLocale.invoke(null);

  final ThemeRepository themeRepository = StoredThemeRepository(preferences);
  final loadAppThemeMode = LoadAppThemeMode(themeRepository);
  final setAppThemeMode = SetAppThemeMode(themeRepository);
  final initialThemeMode = await loadAppThemeMode.invoke(null);

  debugPrint('main: Preferences initialized successfully');

  debugPrint('env: ${EnvConfig.appEnv}');
  debugPrint('apiBaseUrl: ${EnvConfig.apiBaseUrl}');
  debugPrint('tmdbBearerToken: ${EnvConfig.tmdbBearerToken}');

  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        if (EnvConfig.tmdbBearerToken.isNotEmpty)
          'Authorization': 'Bearer ${EnvConfig.tmdbBearerToken}',
      },
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

  final networkClient = NetworkClient(dio);
  final database = await db.database;

  debugPrint('main: NetworkClient initialized successfully');

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Database>.value(value: database),
        RepositoryProvider<Preferences>.value(value: preferences),
        RepositoryProvider<NetworkClient>.value(value: networkClient),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>(
            create: (_) => LocaleCubit(
              loadAppLocale: loadAppLocale,
              setAppLocale: setAppLocale,
              initialLocale: initialLocale,
            ),
          ),
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(
              loadAppThemeMode: loadAppThemeMode,
              setAppThemeMode: setAppThemeMode,
              initialMode: initialThemeMode,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;
    final themeMode = context.watch<ThemeCubit>().state;

    return MaterialApp(
      locale: locale,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      home: const RootShellPage(),
    );
  }
}
