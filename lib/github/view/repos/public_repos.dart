import 'package:flutter/material.dart';
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
        await gitHubAPI.fetchRepos(includeForks: false);

    // Custom sort: prioritize by homepage presence, then by star count
    fetchedRepos.sort((a, b) {
      // Check homepage presence: repositories with a homepage come first
      int homepageComparison =
          (b.homepage != null && b.homepage!.isNotEmpty ? 1 : 0) -
              (a.homepage != null && a.homepage!.isNotEmpty ? 1 : 0);
      if (homepageComparison != 0) {
        return homepageComparison;
      }
      // If both have or don't have a homepage, then sort by star count
      return (b.stargazersCount ?? 0).compareTo(a.stargazersCount ?? 0);
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
        return ListView.builder(
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
                    subtitle:
                        Text(repo.description?.toString() ?? 'No Description'),
                    trailing: ElevatedButton(
                      onPressed:
                          repo.homepage != null && repo.homepage!.isNotEmpty
                              ? () => _launchURL(repo.homepage!)
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
        );
      },
    );
  }
}
