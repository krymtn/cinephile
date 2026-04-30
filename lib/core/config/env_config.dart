import 'package:cinephileapp/core/config/app_environment.dart';

class EnvConfig {
  // We use String.fromEnvironment which injects the values at compile time.
  // We also provide safe fallbacks just in case a variable is missing.

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    // Must match [AppEnvironment.dev.value] (const context cannot use enum fields).
    defaultValue: 'dev',
  );

  static AppEnvironment get environment => AppEnvironment.fromValue(appEnv);

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.themoviedb.org/3',
  );

  static const String tmdbBearerToken = String.fromEnvironment(
    'TMDB_BEARER_TOKEN',
    defaultValue: '',
  );

  // Helper getters (delegate to [AppEnvironmentX])
  static bool get isDev => environment.isDev;

  static bool get isStaging => environment.isStaging;

  static bool get isProd => environment.isProd;
}
