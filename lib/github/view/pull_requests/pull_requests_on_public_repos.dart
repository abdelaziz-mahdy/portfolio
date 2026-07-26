import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/pull_requests/repository_card.dart';

class PullRequestsOnPublicRepos extends StatelessWidget {
  final PortfolioData data;
  final double cardWidth;

  const PullRequestsOnPublicRepos({
    super.key,
    required this.data,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSummary(context),
        StaggeredGrid.count(
          crossAxisCount: isPortrait(context) ? 1 : 2,
          children: data.contributions
              .map((contribution) => RepositoryCard(
                    contribution: contribution,
                    cardWidth: cardWidth,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Summary of Pull Requests on Public Repos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Total Repositories: ${data.contributions.length}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Total PRs: ${data.totalPullRequests}",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.pullRequestStates.entries.map((entry) {
              return Chip(
                label: Text(
                  "${entry.key}: ${entry.value}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                ),
                backgroundColor: getStateColor(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
