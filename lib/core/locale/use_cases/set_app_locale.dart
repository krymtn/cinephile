import 'package:flutter/material.dart';

import 'package:cinephileapp/core/extensions/language_locale.dart';
import 'package:cinephileapp/core/locale/locale_repository.dart';
import 'package:cinephileapp/core/use_case/use_case.dart';
import 'package:cinephileapp/core/use_case/use_case_input.dart';

final class SetAppLocaleInput extends UseCaseInput {
  const SetAppLocaleInput(this.languageCodeRaw);

  final String languageCodeRaw;

  String get normalized => languageCodeRaw.trim().toLowerCase();
}

final class SetAppLocale extends UseCase<SetAppLocaleInput, Locale> {
  SetAppLocale(this._repository);

  final LocaleRepository _repository;

  @override
  String get name => 'setAppLocale';

  @override
  Future<Locale> invoke(
    SetAppLocaleInput input, {
    UseCaseProgress? onProgress,
  }) async {
    final code = input.normalized;
    await _repository.setLanguageCode(code);
    return code.locale;
  }
}
