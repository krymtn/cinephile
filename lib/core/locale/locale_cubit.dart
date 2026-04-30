import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cinephileapp/core/extensions/language_locale.dart';

import 'locale_repository.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._repository, Locale initial) : super(initial);

  final LocaleRepository _repository;

  Future<void> setLanguage(String languageCode) async {
    final code = languageCode.trim().toLowerCase();
    await _repository.setLanguageCode(code);
    emit(code.locale);
  }
}
