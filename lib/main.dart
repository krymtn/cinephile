import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'core/config/env_config.dart';
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
import 'l10n/generated/app_localizations.dart';
import 'theme/app_theme.dart';
import 'theme/theme_extension.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  debugPrint('main: NetworkClient initialized successfully');

  runApp(
    MultiRepositoryProvider(
      providers: [
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.dark_mode_outlined),
            tooltip: context.l10n.themeAppearance,
            onSelected: (mode) => context.themeCubit.setThemeMode(mode),
            itemBuilder: (menuContext) => [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Text(menuContext.l10n.themeSystem),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Text(menuContext.l10n.themeLight),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Text(menuContext.l10n.themeDark),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language_outlined),
            onSelected: (code) => context.localeCubit.setLanguage(code),
            itemBuilder: (menuContext) => [
              PopupMenuItem(
                value: 'en',
                child: Text(menuContext.l10n.languageEnglish),
              ),
              PopupMenuItem(
                value: 'tr',
                child: Text(menuContext.l10n.languageTurkish),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.counterHint),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.themeAppearance,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              _themeModeLabel(context, context.watch<ThemeCubit>().state),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appThemeColors.detailBody,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: context.l10n.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _themeModeLabel(BuildContext context, ThemeMode mode) {
  final l10n = context.l10n;
  return switch (mode) {
    ThemeMode.system => l10n.themeSystem,
    ThemeMode.light => l10n.themeLight,
    ThemeMode.dark => l10n.themeDark,
  };
}
