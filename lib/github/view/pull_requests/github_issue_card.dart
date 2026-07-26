import 'package:flutter/material.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';

class GithubIssueCard extends StatelessWidget {
  final PortfolioPullRequest pullRequest;

  const GithubIssueCard({super.key, required this.pullRequest});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () => openExternalUrl(context, pullRequest.link),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(pullRequest.title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pullRequest.state,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.circle, color: getStateColor(pullRequest.state)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
