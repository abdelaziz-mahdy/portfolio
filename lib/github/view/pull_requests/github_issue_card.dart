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
      child: ListTile(
          title: Text(issue.title ?? 'No title'),
          trailing: Icon(Icons.circle, color: getStateColor(issue.state)),
          onTap: () async {
            final url = issue.htmlUrl;
            if (url != null && await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            } else {
              // Optionally, show an error or a message if the URL can't be opened
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open the issue.')),
              );
            }
          }),
    );
  }
}
