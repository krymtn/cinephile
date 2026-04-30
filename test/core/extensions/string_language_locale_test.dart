import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/core/extensions/language_locale.dart';

void main() {
  group('StringPreferencesLanguageLocaleX.locale', () {
    test("'en' resolves to English locale", () {
      expect('en'.locale, const Locale('en'));
      expect(' EN '.locale, const Locale('en'));
    });

    test("'tr' resolves to Turkish locale", () {
      expect('tr'.locale, const Locale('tr'));
      expect('\tTR'.locale, const Locale('tr'));
    });

    test('unknown codes fall back to English', () {
      expect('fr'.locale, const Locale('en'));
      expect('en-US'.locale, const Locale('en'));
      expect('xxx'.locale, const Locale('en'));
    });

    test('blank values fall back to English', () {
      expect(''.locale, const Locale('en'));
      expect('   '.locale, const Locale('en'));
    });
  });
}
