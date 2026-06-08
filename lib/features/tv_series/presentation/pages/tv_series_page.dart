import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../root/presentation/widgets/app_settings_sheet.dart';
import '../../domain/use_cases/use_cases.dart';
import '../cubits/cubits.dart';
import '../tv_home_sections.dart';
import '../widgets/catalog_section.dart';
import 'tv_series_catalog_list_page.dart';

/// TV series tab: stacked landscape rails — one horizontal list per category.
class TvSeriesPage extends StatelessWidget {
  const TvSeriesPage({super.key});

  static const double _sectionSpacing = 28;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TvSeriesHomeCubit(
        loadTvSeriesCatalogPage: context.read<LoadTvSeriesCatalogPage>(),
        syncTvSeriesCatalogPage: context.read<SyncTvSeriesCatalogPage>(),
      )..loadInitial(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.navTvSeries),
          actions: [
            IconButton(
              onPressed: () => showAppSettingsSheet(context),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: BlocBuilder<TvSeriesHomeCubit, TvSeriesHomeState>(
          builder: (context, state) {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              itemCount: tvHomeSectionKinds.length,
              separatorBuilder: (_, _) => const SizedBox(height: _sectionSpacing),
              itemBuilder: (context, index) {
                final kind = tvHomeSectionKinds[index];
                final sectionState =
                    state.sections[kind] ?? const TvSectionInitial();
                return TvSeriesCatalogSection(
                  title: tvSectionTitle(kind),
                  sectionState: sectionState,
                  onSeeAll: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TvSeriesCatalogListPage(kind: kind),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
