import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinephileapp/core/extensions/language_locale.dart';
import 'package:cinephileapp/core/locale/locale_cubit.dart';
import 'package:cinephileapp/core/locale/locale_repository.dart';
import 'package:cinephileapp/core/locale/use_cases/load_app_locale.dart';
import 'package:cinephileapp/core/locale/use_cases/set_app_locale.dart';

class _FakeLocaleRepository implements LocaleRepository {
  String _code;

  _FakeLocaleRepository(this._code);

  String get storedCode => _code;

  @override
  Future<Locale> loadLocale() async => _code.locale;

  @override
  Future<void> setLanguageCode(String code) async {
    _code = code;
  }
}

void main() {
  group('LocaleCubit', () {
    late _FakeLocaleRepository repo;
    late LoadAppLocale loadAppLocale;
    late SetAppLocale setAppLocale;

    setUp(() {
      repo = _FakeLocaleRepository('en');
      loadAppLocale = LoadAppLocale(repo);
      setAppLocale = SetAppLocale(repo);
    });

    test('setLanguage persists code and emits mapped locale', () async {
      final cubit = LocaleCubit(
        loadAppLocale: loadAppLocale,
        setAppLocale: setAppLocale,
        initialLocale: await loadAppLocale.invoke(null),
      );

      await cubit.setLanguage('tr');

      expect(cubit.state, const Locale('tr'));
      expect(repo.storedCode, 'tr');
    });

    test('setLanguage normalizes casing and whitespace', () async {
      repo = _FakeLocaleRepository('tr');
      loadAppLocale = LoadAppLocale(repo);
      setAppLocale = SetAppLocale(repo);

      final cubit = LocaleCubit(
        loadAppLocale: loadAppLocale,
        setAppLocale: setAppLocale,
        initialLocale: await loadAppLocale.invoke(null),
      );

      await cubit.setLanguage(' EN ');

      expect(cubit.state, const Locale('en'));
      expect(repo.storedCode, 'en');
    });

    test('reloadLocale mirrors repository language', () async {
      final cubit = LocaleCubit(
        loadAppLocale: loadAppLocale,
        setAppLocale: setAppLocale,
        initialLocale: await loadAppLocale.invoke(null),
      );

      await repo.setLanguageCode('tr');
      await cubit.reloadLocale();

      expect(cubit.state, const Locale('tr'));
    });
  });
}
