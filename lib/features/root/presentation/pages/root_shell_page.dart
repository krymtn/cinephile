import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../movies/presentation/pages/movies_page.dart';
import '../../domain/root_tab.dart';

/// Root navigation shell hosting Movies, Search, and My list tabs.
///
/// Uses a [TabController] + [TabBarView] so each tab keeps its own subtree when
/// switching. Each tab wraps its content in a [Navigator] so pushes (e.g. movie
/// lists) stay scoped to that tab.
class RootShellPage extends StatefulWidget {
  const RootShellPage({super.key});

  @override
  State<RootShellPage> createState() => _RootShellPageState();
}

class _RootShellPageState extends State<RootShellPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(debugLabel: 'nav_movies'),
    GlobalKey<NavigatorState>(debugLabel: 'nav_search'),
    GlobalKey<NavigatorState>(debugLabel: 'nav_my_list'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: RootTab.values.length,
      vsync: this,
      initialIndex: RootTab.movies.index,
    );
  }

  Future<void> _handlePopInvoked(bool didPop, dynamic result) async {
    if (didPop) return;
    final nav = _navigatorKeys[_tabController.index].currentState;
    if (nav != null && await nav.maybePop()) {
      return;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          _handlePopInvoked(didPop, result),
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _tabNavigator(RootTab.movies),
            _tabNavigator(RootTab.search),
            _tabNavigator(RootTab.myList),
          ],
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            final l10n = context.l10n;
            return NavigationBar(
              selectedIndex: _tabController.index,
              onDestinationSelected: _tabController.animateTo,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.movie_outlined),
                  selectedIcon: const Icon(Icons.movie_rounded),
                  label: l10n.navMovies,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.search_rounded),
                  selectedIcon: const Icon(Icons.search),
                  label: l10n.navSearch,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.format_list_bulleted_rounded),
                  selectedIcon: const Icon(Icons.list_alt_rounded),
                  label: l10n.navMyList,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _tabNavigator(RootTab tab) {
    return Navigator(
      key: _navigatorKeys[tab.index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => _RootTabRoot(tab: tab),
        );
      },
    );
  }
}

class _RootTabRoot extends StatelessWidget {
  const _RootTabRoot({required this.tab});

  final RootTab tab;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      RootTab.movies => const MoviesPage(),
      RootTab.search => const _SearchTabPlaceholder(),
      RootTab.myList => const _MyListTabPlaceholder(),
    };
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
