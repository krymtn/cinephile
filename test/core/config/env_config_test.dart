import 'package:cinephileapp/core/config/app_environment.dart';
import 'package:cinephileapp/core/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

/// [EnvConfig] reads compile-time [String.fromEnvironment] values.
///
/// These tests assert the **default** values used when you run plain
/// `flutter test` with no `--dart-define` / `--dart-define-from-file`.
///
/// To verify overrides (e.g. `APP_ENV=staging`), run the same file with defines:
/// `flutter test --dart-define=APP_ENV=staging test/core/config/env_config_test.dart`
void main() {
  group('EnvConfig (vanilla flutter test — no dart-define)', () {
    test('appEnv defaults to dev and maps to environment', () {
      expect(EnvConfig.appEnv, 'dev');
      expect(EnvConfig.environment, AppEnvironment.dev);
      expect(EnvConfig.isDev, isTrue);
      expect(EnvConfig.isStaging, isFalse);
      expect(EnvConfig.isProd, isFalse);
    });

    test('apiBaseUrl uses default when not overridden', () {
      expect(
        EnvConfig.apiBaseUrl,
        'https://api.themoviedb.org/3',
      );
    });

    test('tmdbBearerToken defaults to empty string', () {
      expect(EnvConfig.tmdbBearerToken, '');
    });
  });
}
