import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cinephileapp/core/locale/locale_cubit.dart';
import 'package:cinephileapp/l10n/generated/app_localizations.dart';

extension BuildContextX on BuildContext {
  LocaleCubit get localeCubit => read<LocaleCubit>();

  /// [AppLocalizations] for this subtree; requires localization delegates above.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
