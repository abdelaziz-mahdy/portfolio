import 'package:flutter/material.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/widgets/card_grid.dart';
import 'package:portfolio/github/view/widgets/section_header.dart';
import 'package:portfolio/layout/breakpoints.dart';
import 'package:portfolio/theme/portfolio_palette.dart';

/// The user's own public repositories.
class RepositoriesList extends StatefulWidget {
  static const routeName = '/repositories';

  final List<PortfolioRepository> repositories;

  const RepositoriesList({super.key, required this.repositories});

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  bool _showAll = false;

  /// Shown before the reader asks for the rest. 73 cards up front was most of
  /// the page's height for a list whose tail is mostly unstarred and
  /// undescribed.
  static const _initialCount = 9;

  @override
  Widget build(BuildContext context) {
    final all = widget.repositories;
    final visible = _showAll ? all : all.take(_initialCount).toList();
    final hidden = all.length - visible.length;
    final withDemo = all.where((r) => r.hasDemo).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = LayoutMetrics.of(constraints.maxWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeader(
              title: 'Projects',
              subtitle: '${all.length} public repositories · '
                  '$withDemo with a live demo',
            ),
            const SizedBox(height: 20),
            CardGrid(
              // Derived from the measured width. The previous version passed
              // crossAxisCount: 2 unconditionally, which overflowed every
              // phone.
              columns: metrics.columnsFor(minCardWidth: 320, max: 3),
              children: visible
                  .map((repo) => _RepositoryCard(
                        key: ValueKey(repo.fullName),
                        repository: repo,
                      ))
                  .toList(),
            ),
            if (hidden > 0 || _showAll) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showAll = !_showAll),
                  icon: Icon(_showAll ? Icons.expand_less : Icons.expand_more),
                  label: Text(_showAll
                      ? 'Show fewer'
                      : 'Show $hidden more projects'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RepositoryCard extends StatelessWidget {
  final PortfolioRepository repository;

  const _RepositoryCard({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openExternalUrl(context, repository.link),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      repository.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (repository.stars > 0) ...[
                    const SizedBox(width: 8),
                    Semantics(
                      label: '${repository.stars} stars',
                      excludeSemantics: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star,
                              size: 15, color: context.palette.star),
                          const SizedBox(width: 3),
                          Text(formatCount(repository.stars),
                              style: theme.textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              if (repository.description != null) ...[
                const SizedBox(height: 6),
                Text(
                  repository.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (repository.language != null)
                    Text(
                      repository.language!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const Spacer(),
                  // Rendered only when a demo exists. Previously every card
                  // carried a Demo button and 50 of the 73 were permanently
                  // disabled — a control that looks tappable but never acts.
                  if (repository.hasDemo)
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          openExternalUrl(context, repository.demoUrl),
                      icon: const Icon(Icons.open_in_new, size: 15),
                      label: const Text('Live demo'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
