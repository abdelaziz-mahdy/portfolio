import 'package:flutter/material.dart';
import 'package:portfolio/github/models/github_issue.dart';
import 'package:portfolio/github/view/pull_requests/github_issue_card.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryCard extends StatelessWidget {
  final String repositoryUrl;
  final List<GithubIssue> issues;
  final double cardWidth;

  const RepositoryCard({
    super.key,
    required this.repositoryUrl,
    required this.issues,
    required this.cardWidth,
  });

  Future<void> _launchURL(String url) async {
    url = url.replaceFirst("api.github.com", "github.com");
    url = url.replaceFirst("/repos/", "/");
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => _launchURL(repositoryUrl),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    repositoryUrl.split('/').last,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ),
              ...issues.map((issue) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                        width: cardWidth, child: GithubIssueCard(issue: issue)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
