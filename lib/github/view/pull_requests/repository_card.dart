import 'package:flutter/material.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/pull_requests/github_issue_card.dart';

class RepositoryCard extends StatelessWidget {
  final ContributedRepository contribution;
  final double cardWidth;
  final bool summary;

  const RepositoryCard({
    super.key,
    required this.contribution,
    required this.cardWidth,
    this.summary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => openExternalUrl(context, contribution.repoLink),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  contribution.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (summary)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: contribution.pullRequestStates.entries.map((entry) {
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
              )
            else
              ...contribution.pullRequests.map((pullRequest) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                      width: cardWidth,
                      child: GithubIssueCard(pullRequest: pullRequest),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
