import 'package:flutter/material.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/pull_requests/repository_card.dart';
import 'package:portfolio/github/view/widgets/card_grid.dart';
import 'package:portfolio/github/view/widgets/pr_state_chip.dart';
import 'package:portfolio/github/view/widgets/section_header.dart';
import 'package:portfolio/layout/breakpoints.dart';

/// Open-source contributions, ranked.
///
/// The previous version gave all 42 repositories an identical card. The top
/// five hold 89.9% of the pull requests and 25 repositories have exactly one,
/// so most of the section was a wall of cards reading "merged: 1" — the reader
/// had to do the ranking that this widget should have done for them.
class PullRequestsOnPublicRepos extends StatefulWidget {
  final PortfolioData data;

  const PullRequestsOnPublicRepos({super.key, required this.data});

  @override
  State<PullRequestsOnPublicRepos> createState() =>
      _PullRequestsOnPublicReposState();
}

class _PullRequestsOnPublicReposState extends State<PullRequestsOnPublicRepos> {
  bool _showAll = false;

  /// Repositories promoted to a full card. The rest go to the compact list.
  static const _featuredCount = 6;

  @override
  Widget build(BuildContext context) {
    final contributions = widget.data.contributions;
    final featured = contributions.take(_featuredCount).toList();
    final tail = contributions.skip(_featuredCount).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = LayoutMetrics.of(constraints.maxWidth);
        final columns = metrics.columnsFor(minCardWidth: 380, max: 2);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeader(
              title: 'Open-source contributions',
              subtitle:
                  '${widget.data.totalPullRequests} pull requests across '
                  '${contributions.length} public repositories',
              trailing: PrStateChips(states: widget.data.pullRequestStates),
            ),
            const SizedBox(height: 20),
            CardGrid(
              columns: columns,
              children: featured
                  .map((c) => RepositoryCard(
                        key: ValueKey(c.fullName),
                        contribution: c,
                      ))
                  .toList(),
            ),
            if (tail.isNotEmpty) ...[
              const SizedBox(height: 20),
              _TailList(
                contributions: tail,
                expanded: _showAll,
                columns: columns,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showAll = !_showAll),
                  icon: Icon(_showAll ? Icons.expand_less : Icons.expand_more),
                  label: Text(_showAll
                      ? 'Show fewer'
                      : 'Show ${tail.length} more repositories'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// The long tail, as compact rows rather than full cards.
///
/// Same information, a fraction of the height: a repository with one merged
/// pull request does not warrant the same screen space as one with 487.
class _TailList extends StatelessWidget {
  final List<ContributedRepository> contributions;
  final bool expanded;
  final int columns;

  const _TailList({
    required this.contributions,
    required this.expanded,
    required this.columns,
  });

  /// Rows shown while collapsed.
  static const _collapsedCount = 4;

  @override
  Widget build(BuildContext context) {
    final visible =
        expanded ? contributions : contributions.take(_collapsedCount).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: CardGrid(
          columns: columns,
          spacing: 0,
          equalHeights: false,
          children: visible
              .map((c) => _TailRow(key: ValueKey(c.fullName), contribution: c))
              .toList(),
        ),
      ),
    );
  }
}

class _TailRow extends StatelessWidget {
  final ContributedRepository contribution;

  const _TailRow({super.key, required this.contribution});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = contribution.pullRequests.length;

    return InkWell(
      onTap: () => openExternalUrl(context, contribution.repoLink),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        // 44px minimum interactive height.
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                contribution.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$count PR${count == 1 ? '' : 's'}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

