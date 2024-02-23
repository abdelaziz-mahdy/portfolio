import 'package:flutter/material.dart';
import 'package:portfolio/github/models/github_issue.dart';

class GithubIssuesList extends StatelessWidget {
  final List<GithubIssue> issues;

  const GithubIssuesList({super.key, required this.issues});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(issue.title ?? 'No title'),
            subtitle: Text(issue.body?.toString() ?? 'No description'),
            leading: issue.user?.avatarUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(issue.user!.avatarUrl!),
                  )
                : null,
            trailing: Text(issue.state ?? 'No state'),
            onTap: () {
              // Handle tap if needed, for example opening issue URL
              if (issue.htmlUrl != null) {
                // Use your preferred method/package to open URLs, like url_launcher
              }
            },
          ),
        );
      },
    );
  }
}
