import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:cinephileapp/core/extensions/build_context.dart';
import 'package:cinephileapp/core/locale/locale_cubit.dart';
import 'package:cinephileapp/core/locale/preferences_locale_repository.dart';
import 'package:cinephileapp/core/preferences/preferences.dart';
import 'package:cinephileapp/core/preferences/secure_preference_store.dart';
import 'package:cinephileapp/l10n/generated/app_localizations.dart';
import 'package:cinephileapp/core/config/env_config.dart';
import 'package:cinephileapp/core/network/network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final secureStore = SecurePreferenceStore(const FlutterSecureStorage());
  final preferences = Preferences(secureStore);

  final localeRepository = PreferencesLocaleRepository(preferences);
  final initialLocale = await localeRepository.loadLocale();

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
      child: BlocProvider<LocaleCubit>(
        create: (_) => LocaleCubit(localeRepository, initialLocale),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const MyHomePage(),
        );
      },
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.l10n.homeTitle),
        actions: [
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
