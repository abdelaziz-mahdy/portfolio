import 'package:flutter/material.dart';
import 'package:portfolio/github/models/github_issue.dart';
import 'package:portfolio/github/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class GithubIssueCard extends StatelessWidget {
  final GithubIssue issue;

  const GithubIssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () async {
          final url = issue.htmlUrl;
          if (url != null && await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open the issue.')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(issue.title ?? 'No title',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(issue.body ?? '',
                          overflow: TextOverflow.ellipsis, maxLines: 2)),
                  Icon(Icons.circle, color: getStateColor(issue.state)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
