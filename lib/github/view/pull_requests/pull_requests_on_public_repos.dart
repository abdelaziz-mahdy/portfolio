import 'package:flutter/material.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/github/data/github_data.dart';
import 'package:portfolio/github/models/github_issue.dart';
import 'package:portfolio/github/utils.dart';
import 'package:portfolio/github/view/pull_requests/repository_card.dart';

class PullRequestsOnPublicRepos extends StatefulWidget {
  const PullRequestsOnPublicRepos({super.key});

  @override
  State<PullRequestsOnPublicRepos> createState() =>
      _PullRequestsOnPublicReposState();
}

class _PullRequestsOnPublicReposState extends State<PullRequestsOnPublicRepos> {
  final gitHubAPI = GitHubAPI(
      Constants.githubUsername); // Replace with actual username and token

  Map<String, List<GithubIssue>> groupedIssues = {};
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  // Add these properties to your state class
  int totalRepositories = 0;
  Map<String, int> prStatesSummary = {};

  int totalPRs = 0;

  Future<void> fetchIssues() async {
    isLoading.value = true;
    List<GithubIssue> issues =
        await gitHubAPI.fetchPublicPRs(filterOutsideRepos: true);
    Map<String, List<GithubIssue>> tempGroupedIssues = {};
    Map<String, int> tempPrStatesSummary = {};

    for (var issue in issues) {
      String key = issue.repositoryUrl ?? 'Unknown';
      tempGroupedIssues.putIfAbsent(key, () => []);
      tempGroupedIssues[key]?.add(issue);

      String state = issue.state ?? 'Unknown';
      tempPrStatesSummary[state] = (tempPrStatesSummary[state] ?? 0) + 1;
    }

    groupedIssues = tempGroupedIssues;
    totalRepositories = tempGroupedIssues.length;
    totalPRs = issues.length;
    prStatesSummary = tempPrStatesSummary;

    isLoading.value = false;
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Summary of Pull Requests on Public Repos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Total Repositories: $totalRepositories",
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text("Total PRs: $totalPRs", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: prStatesSummary.entries.map((entry) {
              return Chip(
                label: Text("${entry.key}: ${entry.value}"),
                backgroundColor: getStateColor(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, bool isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildSummary(), // Include the summary at the top

            ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...groupedIssues.entries.map((entry) {
                  return RepositoryCard(
                      repositoryUrl: entry.key, issues: entry.value);
                }),
              ],
            ),
          ],
        );
      },
    );
  }
}
