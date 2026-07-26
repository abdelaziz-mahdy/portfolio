import 'package:flutter/material.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/widgets/pr_state_chip.dart';
import 'package:portfolio/theme/portfolio_palette.dart';

/// A repository the user has contributed pull requests to.
///
/// The previous card showed a name and a count and discarded the rest. The
/// description, the star count and the pull request titles were all already in
/// the dataset — without them, "dio — merged: 1" means nothing to a reader who
/// does not already know what `dio` is.
class RepositoryCard extends StatefulWidget {
  final ContributedRepository contribution;

  const RepositoryCard({super.key, required this.contribution});

  @override
  State<RepositoryCard> createState() => _RepositoryCardState();
}

class _RepositoryCardState extends State<RepositoryCard> {
  bool _expanded = false;

  /// How many pull request titles to show before offering the rest.
  static const _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contribution = widget.contribution;
    final pullRequests = contribution.pullRequests;
    final visible =
        _expanded ? pullRequests : pullRequests.take(_previewCount).toList();
    final hidden = pullRequests.length - visible.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(contribution: contribution),
            if (contribution.repoDescription != null) ...[
              const SizedBox(height: 6),
              Text(
                contribution.repoDescription!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            PrStateChips(states: contribution.pullRequestStates),
            if (visible.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 4),
              ...visible.map((pr) => _PullRequestRow(pullRequest: pr)),
            ],
            if (hidden > 0 || _expanded)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded
                      ? 'Show fewer'
                      : 'Show $hidden more pull request${hidden == 1 ? '' : 's'}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ContributedRepository contribution;

  const _Header({required this.contribution});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => openExternalUrl(context, contribution.repoLink),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '${contribution.owner}/',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: contribution.name,
                          style: theme.textTheme.titleMedium,
                        ),
                      ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.open_in_new,
                      size: 14, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _StarCount(stars: contribution.repoStars),
      ],
    );
  }
}

class _StarCount extends StatelessWidget {
  final int stars;

  const _StarCount({required this.stars});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$stars stars',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colour comes from the theme extension. A hard-coded
            // Colors.yellow sat at 1.22:1 against a light card.
            Icon(Icons.star, size: 15, color: context.palette.star),
            const SizedBox(width: 3),
            Text(formatCount(stars), style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _PullRequestRow extends StatelessWidget {
  final PortfolioPullRequest pullRequest;

  const _PullRequestRow({required this.pullRequest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return InkWell(
      onTap: () => openExternalUrl(context, pullRequest.link),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                _glyph(pullRequest.state),
                size: 15,
                color: palette.forState(pullRequest.state),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                pullRequest.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _glyph(String state) {
    switch (state) {
      case 'merged':
        return Icons.call_merge;
      case 'open':
        return Icons.radio_button_unchecked;
      case 'closed':
        return Icons.close;
      default:
        return Icons.help_outline;
    }
  }
}
