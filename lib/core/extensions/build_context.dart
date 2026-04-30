import 'package:flutter/widgets.dart';

import 'package:cinephileapp/l10n/generated/app_localizations.dart';

extension BuildContextX on BuildContext {
  /// [AppLocalizations] for this subtree; requires localization delegates above.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
