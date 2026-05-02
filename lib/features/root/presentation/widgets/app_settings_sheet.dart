import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../theme/app_theme.dart';
import 'settings_option_card.dart';
import 'settings_section_label.dart';
import 'settings_sheet_header.dart';

/// Modal sheet for theme and language, aligned with the Cinephile settings mock.
///
/// Uses a transparent route background and paints the chrome with [Theme]'s colors
/// so switching Dark/Light while the sheet is open updates instantly. The route's
/// [showModalBottomSheet] `backgroundColor` is sticky on open and would otherwise
/// stay pale when adopting dark theme from inside the sheet.
Future<void> showAppSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radiusLg),
      ),
    ),
    builder: (sheetContext) {
      return BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (_, themeMode) {
          final scheme = Theme.of(sheetContext).colorScheme;
          return Material(
            color: scheme.surfaceContainer,
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusLg),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 12,
                bottom: MediaQuery.paddingOf(sheetContext).bottom + 16,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SettingsSheetHeader(
                      onClose: () => Navigator.of(sheetContext).pop(),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<LocaleCubit, Locale>(
                      builder: (_, locale) {
                        final l10n = sheetContext.l10n;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SettingsSectionLabel(
                              text: l10n.settingsSectionAppearance,
                            ),
                            SettingsOptionCard(
                              selected: themeMode == ThemeMode.dark,
                              title: l10n.themeDark,
                              subtitle: l10n.settingsThemeDarkSubtitle,
                              onTap: () => sheetContext.themeCubit.setThemeMode(
                                ThemeMode.dark,
                              ),
                            ),
                            SettingsOptionCard(
                              selected: themeMode == ThemeMode.light,
                              title: l10n.themeLight,
                              subtitle: l10n.settingsThemeLightSubtitle,
                              onTap: () => sheetContext.themeCubit.setThemeMode(
                                ThemeMode.light,
                              ),
                            ),
                            SettingsOptionCard(
                              selected: themeMode == ThemeMode.system,
                              title: l10n.themeSystem,
                              subtitle: l10n.settingsThemeSystemSubtitle,
                              onTap: () => sheetContext.themeCubit.setThemeMode(
                                ThemeMode.system,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SettingsSectionLabel(
                              text: l10n.settingsSectionLanguage,
                            ),
                            SettingsOptionCard(
                              selected: locale.languageCode == 'en',
                              title: l10n.languageEnglish,
                              subtitle: l10n.settingsLangCodeEn,
                              onTap: () =>
                                  sheetContext.localeCubit.setLanguage('en'),
                            ),
                            SettingsOptionCard(
                              selected: locale.languageCode == 'tr',
                              title: l10n.languageTurkish,
                              subtitle: l10n.settingsLangCodeTr,
                              onTap: () =>
                                  sheetContext.localeCubit.setLanguage('tr'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
