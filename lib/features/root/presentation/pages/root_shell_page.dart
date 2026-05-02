import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context.dart';
import '../../domain/root_tab.dart';
import '../widgets/app_settings_sheet.dart';
import '../widgets/root_bottom_nav_bar.dart';

/// Root navigation shell hosting Movies, Search, and My list tabs.
///
/// Selected tab state is driven by a [ValueNotifier] and [ValueListenableBuilder].
/// We do **not** use Bloc/Cubit here: changing tabs is transient UI state with no
/// business rules, persistence, or coordination across features. Introducing Bloc
/// would mean extra types and tests for logic that assigns one enum field—use Bloc
/// when tab changes trigger side effects (analytics, auth gates, restoring deep
/// links) or when multiple distant widgets must react to the same navigation state.
class RootShellPage extends StatefulWidget {
  const RootShellPage({super.key});

  @override
  State<RootShellPage> createState() => _RootShellPageState();
}

class _RootShellPageState extends State<RootShellPage> {
  late final ValueNotifier<RootTab> _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = ValueNotifier(RootTab.movies);
  }

  @override
  void dispose() {
    _selectedTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RootTab>(
      valueListenable: _selectedTab,
      builder: (context, selected, _) {
        return Scaffold(
          body: IndexedStack(
            index: selected.index,
            children: const [
              _MoviesTabPlaceholder(),
              _SearchTabPlaceholder(),
              _MyListTabPlaceholder(),
            ],
          ),
          bottomNavigationBar: RootBottomNavBar(
            selected: selected,
            onSelect: (tab) {
              _selectedTab.value = tab;
            },
          ),
        );
      },
    );
  }
}

/// Placeholders until Movies / Search / My list features expose real pages.
class _MoviesTabPlaceholder extends StatelessWidget {
  const _MoviesTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navMovies),
        actions: [
          IconButton(
            tooltip: context.l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => showAppSettingsSheet(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          context.l10n.navMovies,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SearchTabPlaceholder extends StatelessWidget {
  const _SearchTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.navSearch));
  }
}

class _MyListTabPlaceholder extends StatelessWidget {
  const _MyListTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.navMyList));
  }
}
