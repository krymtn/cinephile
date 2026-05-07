import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'use_cases/load_app_theme_mode.dart';
import 'use_cases/set_app_theme_mode.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({
    required LoadAppThemeMode loadAppThemeMode,
    required SetAppThemeMode setAppThemeMode,
    required ThemeMode initialMode,
  }) : _loadAppThemeMode = loadAppThemeMode,
       _setAppThemeMode = setAppThemeMode,
       super(initialMode);

  final LoadAppThemeMode _loadAppThemeMode;
  final SetAppThemeMode _setAppThemeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(await _setAppThemeMode.invoke(SetAppThemeModeInput(mode)));
  }

  Future<void> reloadThemeMode() async {
    emit(await _loadAppThemeMode.invoke(null));
  }
}
