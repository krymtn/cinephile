import 'package:flutter/material.dart';

import 'package:cinephileapp/core/theme/theme_repository.dart';
import 'package:cinephileapp/core/use_case/use_case.dart';

final class LoadAppThemeMode extends UseCase<void, ThemeMode> {
  LoadAppThemeMode(this._repository);

  final ThemeRepository _repository;

  @override
  String get name => 'loadAppThemeMode';

  @override
  Future<ThemeMode> invoke(void _, {UseCaseProgress? onProgress}) {
    return _repository.loadThemeMode();
  }

  @override
  String keyOf(void _) => name;
}
