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

  Future<List<String>> fetchUserOrgs() async {
    List<String> orgs = [];
    try {
      final response =
          await _dio.get('https://api.github.com/users/$username/orgs');
      final List<dynamic> orgData = response.data;
      for (var org in orgData) {
        orgs.add(org['login']); // 'login' is the organization's username
      }
    } catch (e, stackTrace) {
      print('Failed to fetch organizations: $e $stackTrace');
      if (e is DioException) {
        if (e.response?.data['message'] != null) {
          throw Exception(e.response?.data['message']);
        }
      }
      rethrow;
    }
    return orgs;
  }

  Future<List<GithubRepository>> fetchAllReposForUserAndOrgs(
      {bool includeForks = true}) async {
    List<GithubRepository> allRepos = [];
    // Fetch user's repos
    allRepos.addAll(await fetchRepos(includeForks: includeForks));

    // Fetch user's organizations
    List<String> orgs = await fetchUserOrgs();
    // print("Orgs: $orgs");
    // Fetch repos for each organization
    for (String orgName in orgs) {
      List<GithubRepository> orgRepos =
          await fetchRepos(includeForks: includeForks, orgName: orgName);
      allRepos.addAll(orgRepos);
    }

    return allRepos;
  }

  Future<List<GithubRepository>> fetchRepos(
      {bool includeForks = true, String? orgName}) async {
    List<GithubRepository> repos = [];
    int page = 1;
    const int perPage = 100;
    String baseUrl = orgName == null
        ? 'https://api.github.com/users/$username/repos'
        : 'https://api.github.com/orgs/$orgName/repos';

    try {
      while (true) {
        final response = await _dio.get(
          baseUrl,
          queryParameters: {
            'page': page,
            'per_page': perPage,
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
      if (e is DioException) {
        if (e.response?.data['message'] != null) {
          throw Exception(e.response?.data['message']);
        }
      }
      rethrow;
    }
  }

  Future<String> fetchUserAvatarUrl() async {
    try {
      final response = await _dio.get('https://api.github.com/users/$username');
      return response.data['avatar_url'] as String;
    } catch (e, stackTrace) {
      print('Failed to fetch user avatar: $e $stackTrace');
      if (e is DioException) {
        if (e.response?.data['message'] != null) {
          throw Exception(e.response?.data['message']);
        }
      }
      rethrow;
    }
  }
}
