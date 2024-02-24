import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio/constants.dart';
import 'package:portfolio/github/data/github_data.dart';
import 'package:portfolio/github/models/github_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoriesList extends StatefulWidget {
  const RepositoriesList({super.key});

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  final GitHubAPI gitHubAPI = GitHubAPI(Constants.githubUsername);
  List<GithubRepository> repositories = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> fetchRepositories() async {
    isLoading.value = true;
    List<GithubRepository> fetchedRepos =
        await gitHubAPI.fetchAllReposForUserAndOrgs(includeForks: false);

    fetchedRepos.sort((a, b) {
      // First, sort by star count in descending order
      int starComparison =
          (b.stargazersCount ?? 0).compareTo(a.stargazersCount ?? 0);
      if (starComparison != 0) {
        return starComparison; // Prioritize by star count first
      }
      // If star counts are equal, prioritize by homepage presence
      return (b.doesDemoExist() ? 1 : 0) - (a.doesDemoExist() ? 1 : 0);
    });

    repositories = fetchedRepos;
    isLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the repository URL.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (_, isLoading, __) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(children: [
          const Text("Public Repos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            Text(" ${repo.stargazersCount ?? 0}"),
                            const SizedBox(width: 8),
                            Expanded(child: Text(repo.name ?? 'No Name')),
                          ],
                        ),
                        subtitle: Text(
                            repo.description?.toString() ?? 'No Description'),
                        trailing: ElevatedButton(
                          onPressed: repo.doesDemoExist()
                              ? () => _launchURL(repo.getDemoUrl())
                              : null,
                          child: const Text('Demo'),
                        ),
                        onTap: () => _launchURL(repo.htmlUrl ?? ''),
                      ),
                      // // Language Card
                      // if (repo.language != null)
                      //   Container(
                      //     alignment: Alignment.centerRight,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 8),
                      //     child: Chip(
                      //       label: Text(repo.language ?? 'Language: Unknown'),
                      //       avatar: const Icon(Icons.code, size: 20.0),
                      //     ),
                      //   ),
                    ],
                  ),
                );
              },
            ),
          )
        ]);
      },
    );
  }
}
