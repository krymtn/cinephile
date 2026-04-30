import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cinephileapp/core/extensions/language_locale.dart';
import 'package:cinephileapp/core/locale/locale_cubit.dart';
import 'package:cinephileapp/core/locale/locale_repository.dart';

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
    test('setLanguage persists code and emits mapped locale', () async {
      final repo = _FakeLocaleRepository('en');
      final cubit = LocaleCubit(repo, await repo.loadLocale());

      await cubit.setLanguage('tr');

      expect(cubit.state, const Locale('tr'));
      expect(repo.storedCode, 'tr');
    });

    test('setLanguage normalizes casing and whitespace', () async {
      final repo = _FakeLocaleRepository('tr');
      final cubit = LocaleCubit(repo, await repo.loadLocale());

      await cubit.setLanguage(' EN ');

      expect(cubit.state, const Locale('en'));
      expect(repo.storedCode, 'en');
    });
  });
}
