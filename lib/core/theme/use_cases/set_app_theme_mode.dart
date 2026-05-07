import 'package:flutter/material.dart';

import 'package:cinephileapp/core/theme/theme_repository.dart';
import 'package:cinephileapp/core/use_case/use_case.dart';
import 'package:cinephileapp/core/use_case/use_case_input.dart';

final class SetAppThemeModeInput extends UseCaseInput {
  const SetAppThemeModeInput(this.mode);

  final ThemeMode mode;
}

final class SetAppThemeMode extends UseCase<SetAppThemeModeInput, ThemeMode> {
  SetAppThemeMode(this._repository);

  final ThemeRepository _repository;

  @override
  String get name => 'setAppThemeMode';

  @override
  Future<ThemeMode> invoke(
    SetAppThemeModeInput input, {
    UseCaseProgress? onProgress,
  }) async {
    await _repository.setThemeMode(input.mode);
    return input.mode;
  }
}
