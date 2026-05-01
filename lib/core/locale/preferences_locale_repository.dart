import 'package:flutter/material.dart';

import 'package:cinephileapp/core/extensions/language_locale.dart';
import 'package:cinephileapp/core/preferences/keys.dart';
import 'package:cinephileapp/core/preferences/preferences.dart';

import 'locale_repository.dart';

final class PreferencesLocaleRepository implements LocaleRepository {
  PreferencesLocaleRepository(this._preferences);

  final Preferences _preferences;

  @override
  Future<Locale> loadLocale() async {
    final code = await _preferences.readLanguageCodeWithDefault();
    return code.locale;
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await _preferences.write(PreferenceKeys.languageCode, code);
  }
}
