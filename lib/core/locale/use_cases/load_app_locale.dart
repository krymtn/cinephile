import 'package:flutter/material.dart';

import '../../locale/locale_repository.dart';
import '../../use_case/use_case.dart';

final class LoadAppLocale extends UseCase<void, Locale> {
  LoadAppLocale(this._repository);

  final LocaleRepository _repository;

  @override
  String get name => 'loadAppLocale';

  @override
  Future<Locale> invoke(void _, {UseCaseProgress? onProgress}) async {
    return _repository.loadLocale();
  }

  @override
  String keyOf(void _) => name;
}
