import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'use_cases/load_app_locale.dart';
import 'use_cases/set_app_locale.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit({
    required LoadAppLocale loadAppLocale,
    required SetAppLocale setAppLocale,
    required Locale initialLocale,
  }) : _loadAppLocale = loadAppLocale,
       _setAppLocale = setAppLocale,
       super(initialLocale);

  final LoadAppLocale _loadAppLocale;
  final SetAppLocale _setAppLocale;

  Future<void> setLanguage(String languageCode) async {
    emit(await _setAppLocale.invoke(SetAppLocaleInput(languageCode)));
  }

  Future<void> reloadLocale() async {
    emit(await _loadAppLocale.invoke(null));
  }
}
