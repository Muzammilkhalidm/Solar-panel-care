import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/ui_helpers.dart';
import '../../core/widgets/empty_state.dart';
import '../../state/panel_filter.dart';
import '../../state/panels_provider.dart';
import 'widgets/panel_card.dart';

/// All plates with search + status filters.
class PanelsScreen extends StatefulWidget {
  const PanelsScreen({super.key});

  @override
  State<PanelsScreen> createState() => _PanelsScreenState();
}

class _PanelsScreenState extends State<PanelsScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PanelsProvider>().refresh();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette p = context.palette;
    final panels = context.watch<PanelsProvider>();
    final list = panels.filteredPanels;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Solar Plates (${panels.total})',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Register new plate',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addPanel),
            icon: const Icon(Icons.add_circle_outline,
                color: Color(0xFFF7A021)),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 4),
            child: TextField(
              controller: _search,
              onChanged: (v) => context.read<PanelsProvider>().setSearch(v),
              decoration: InputDecoration(
                hintText: 'Search by name, model, device id…',
                prefixIcon: const Icon(Icons.search, size: 21),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _search.clear();
                          context.read<PanelsProvider>().setSearch('');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              children: PanelFilter.values
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f.label),
                        selected: panels.filter == f,
                        onSelected: (_) =>
                            context.read<PanelsProvider>().setFilter(f),
                        selectedColor:
                            const Color(0xFFF7A021).withOpacity(0.25),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: panels.filter == f
                              ? const Color(0xFFF7A021)
                              : p.textSecondary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? (panels.search.isEmpty && panels.filter == PanelFilter.all
                    ? EmptyState(
                        title: AppStrings.noPanelsTitle,
                        message: AppStrings.noPanelsMessage,
                        imageAsset: AppAssets.imgSolarFarm,
                        actionLabel: 'Register Plate',
                        onAction: () =>
                            Navigator.pushNamed(context, AppRoutes.addPanel),
                      )
                    : const EmptyState(
                        title: 'No match',
                        message:
                            'No plate matches this search/filter combination.',
                      ))
                : RefreshIndicator(
                    onRefresh: () => context.read<PanelsProvider>().refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => PanelCard(panel: list[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
