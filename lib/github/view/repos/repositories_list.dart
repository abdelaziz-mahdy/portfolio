import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/github/data/github_data.dart';
import 'package:portfolio/github/models/github_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoriesList extends StatefulWidget {
  static const routeName = '/repositories';
  final double cardWidth;
  const RepositoriesList({super.key, required this.cardWidth});

  @override
  State<RepositoriesList> createState() => _RepositoriesListState();
}

class _RepositoriesListState extends State<RepositoriesList> {
  final GitHubAPI gitHubAPI =
      GitHubAPI(Constants.githubUsername, token: Constants.githubToken);
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
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Public Repos",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16.0),
              StaggeredGrid.count(
                crossAxisCount: 2,
                children: repositories
                    .map((repo) => SizedBox(
                          width: widget.cardWidth,
                          // height: widget.cardWidth,
                          child: InkWell(
                            onTap: () => _launchURL(repo.htmlUrl ?? ''),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.yellow),
                                        Text(" ${repo.stargazersCount ?? 0}"),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child:
                                                Text(repo.name ?? 'No Name')),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                          repo.description?.toString() ??
                                              'No Description'),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: repo.doesDemoExist()
                                            ? () =>
                                                _launchURL(repo.getDemoUrl())
                                            : null,
                                        child: const Text('Demo'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ]);
      },
    );
  }
}
