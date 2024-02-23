import 'package:dio/dio.dart';
import 'package:portfolio/github/models/github_issue.dart';
import 'package:portfolio/github/models/github_repository.dart';

class GitHubAPI {
  final String username;
  final String? token;
  final Dio _dio;

  GitHubAPI(this.username, {this.token}) : _dio = Dio() {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'token $token';
    }
  }

  Future<List<GithubIssue>> fetchPublicPRs(
      {bool filterOutsideRepos = false}) async {
    List<GithubIssue> allPRs = [];
    int page = 1;
    const int perPage = 100;
    try {
      while (true) {
        final response = await _dio.get(
          'https://api.github.com/search/issues',
          queryParameters: {
            'q': 'type:pr author:$username',
            'page': page,
            'per_page': perPage,
          },
        );
        final prs = response.data['items'] as List;
        // print(prs);
        allPRs.addAll(prs.map((e) => GithubIssue.fromJson(e)));

        /// Update the state of the PRs to 'merged' if they have been merged
        for (var element in allPRs) {
          if (element.pullRequest?.mergedAt != null) {
            element.state = 'merged';
          }
        }
        if (prs.length < perPage) {
          break; // Break the loop if there are no more PRs to fetch
        }
        page++;
      }
      if (filterOutsideRepos) {
        allPRs = allPRs.where((pr) {
          if (pr.repositoryUrl == null) {
            print('Skipping PR without repository URL: $pr');
            return false;
          }
          final repoUrlParts = pr.repositoryUrl!.split('/');
          final repoOwner = repoUrlParts[repoUrlParts.length - 2];
          return repoOwner.toLowerCase() != username.toLowerCase();
        }).toList();
      }

      return allPRs;
    } catch (e, stackTrace) {
      print('Failed to fetch pull requests: $e $stackTrace');
      return [];
    }
  }

  Future<List<GithubRepository>> fetchRepos({bool includeForks = true}) async {
    List<GithubRepository> repos = [];
    int page = 1;
    const int perPage = 100;
    try {
      while (true) {
        final response = await _dio.get(
          'https://api.github.com/users/$username/repos',
          queryParameters: {
            'page': page,
            'per_page': perPage,
            'type':
                'owner' // Ensures we only get repositories owned by the user
          },
        );
        final List<dynamic> repoData = response.data;
        for (var repoJson in repoData) {
          bool isFork = repoJson['fork'] as bool;
          if (includeForks || !isFork) {
            repos.add(GithubRepository.fromJson(repoJson));
          }
        }
        if (repoData.length < perPage) {
          break; // Break the loop if there are no more repos to fetch
        }
        page++;
      }
      return repos;
    } catch (e, stackTrace) {
      print('Failed to fetch repositories: $e $stackTrace');
      return [];
    }
  }
}
