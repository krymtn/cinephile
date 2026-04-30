import 'package:cinephileapp/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnvironment.fromValue', () {
    test('maps known strings to enum values', () {
      expect(AppEnvironment.fromValue('dev'), AppEnvironment.dev);
      expect(AppEnvironment.fromValue('staging'), AppEnvironment.staging);
      expect(AppEnvironment.fromValue('prod'), AppEnvironment.prod);
    });

    test('falls back to dev for unknown or empty strings', () {
      expect(AppEnvironment.fromValue(''), AppEnvironment.dev);
      expect(AppEnvironment.fromValue('unknown'), AppEnvironment.dev);
      expect(AppEnvironment.fromValue('PROD'), AppEnvironment.dev);
    });
  });

  group('AppEnvironment.value', () {
    test('matches APP_ENV strings used in dart-define', () {
      expect(AppEnvironment.dev.value, 'dev');
      expect(AppEnvironment.staging.value, 'staging');
      expect(AppEnvironment.prod.value, 'prod');
    });
  });

  group('AppEnvironmentX', () {
    test('isDev / isStaging / isProd / isNotProd', () {
      expect(AppEnvironment.dev.isDev, isTrue);
      expect(AppEnvironment.dev.isStaging, isFalse);
      expect(AppEnvironment.dev.isProd, isFalse);
      expect(AppEnvironment.dev.isNotProd, isTrue);

      expect(AppEnvironment.staging.isStaging, isTrue);
      expect(AppEnvironment.staging.isProd, isFalse);
      expect(AppEnvironment.staging.isNotProd, isTrue);

      expect(AppEnvironment.prod.isProd, isTrue);
      expect(AppEnvironment.prod.isNotProd, isFalse);
    });

    test('when returns the branch for the current case', () {
      expect(
        AppEnvironment.dev.when(
          dev: () => 'd',
          staging: () => 's',
          prod: () => 'p',
        ),
        'd',
      );
      expect(
        AppEnvironment.staging.when(
          dev: () => 'd',
          staging: () => 's',
          prod: () => 'p',
        ),
        's',
      );
      expect(
        AppEnvironment.prod.when(
          dev: () => 'd',
          staging: () => 's',
          prod: () => 'p',
        ),
        'p',
      );
    });
  });
}
