/// Models for `user_info.json`, the static dataset produced in CI by
/// `python/github_user_info.py`.
///
/// The app reads this file instead of calling api.github.com from the browser,
/// which would rate-limit every visitor after 60 requests per hour.
library;

class PortfolioData {
  final String username;
  final String name;
  final String? bio;
  final String imageUrl;
  final String profileUrl;
  final DateTime? generatedAt;
  final List<PortfolioRepository> repositories;
  final List<ContributedRepository> contributions;

  const PortfolioData({
    required this.username,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.profileUrl,
    required this.generatedAt,
    required this.repositories,
    required this.contributions,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    final repositories = (json['repos'] as List? ?? [])
        .map((repo) =>
            PortfolioRepository.fromJson(repo as Map<String, dynamic>))
        .toList();

    final contributions = (json['pull_requests'] as Map? ?? {})
        .entries
        .map((entry) => ContributedRepository.fromJson(
              entry.key as String,
              entry.value as Map<String, dynamic>,
            ))
        .toList();

    // Most stars first; a repo with a live demo wins ties.
    repositories.sort((a, b) {
      final byStars = b.stars.compareTo(a.stars);
      if (byStars != 0) return byStars;
      return (b.hasDemo ? 1 : 0) - (a.hasDemo ? 1 : 0);
    });

    // Ranked by how much was contributed, not by how famous the repo is: the
    // point of the section is the work, and star count breaks ties.
    contributions.sort((a, b) {
      final byVolume = b.pullRequests.length.compareTo(a.pullRequests.length);
      if (byVolume != 0) return byVolume;
      return b.repoStars.compareTo(a.repoStars);
    });

    return PortfolioData(
      username: json['username'] as String,
      name: json['name'] as String? ?? json['username'] as String,
      bio: json['bio'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      profileUrl: json['profile_url'] as String? ??
          'https://github.com/${json['username']}',
      generatedAt: DateTime.tryParse(json['generated_at'] as String? ?? ''),
      repositories: repositories,
      contributions: contributions,
    );
  }

  int get totalStars =>
      repositories.fold(0, (total, repo) => total + repo.stars);

  int get totalPullRequests =>
      contributions.fold(0, (total, repo) => total + repo.pullRequests.length);

  /// PR counts keyed by state, across every external repository.
  Map<String, int> get pullRequestStates {
    final states = <String, int>{};
    for (final contribution in contributions) {
      contribution.pullRequestStates.forEach((state, count) {
        states[state] = (states[state] ?? 0) + count;
      });
    }
    return states;
  }
}

class PortfolioRepository {
  final String name;
  final String fullName;
  final String owner;
  final String link;
  final String? description;
  final int stars;
  final int forks;
  final String? language;
  final List<String> topics;
  final DateTime? updatedAt;
  final bool archived;
  final bool isOrganization;
  final String? demoUrl;

  const PortfolioRepository({
    required this.name,
    required this.fullName,
    required this.owner,
    required this.link,
    required this.description,
    required this.stars,
    required this.forks,
    required this.language,
    required this.topics,
    required this.updatedAt,
    required this.archived,
    required this.isOrganization,
    required this.demoUrl,
  });

  factory PortfolioRepository.fromJson(Map<String, dynamic> json) {
    return PortfolioRepository(
      name: json['name'] as String,
      fullName: json['full_name'] as String? ?? json['name'] as String,
      owner: json['owner'] as String? ?? '',
      link: json['link'] as String,
      description: json['description'] as String?,
      stars: json['stars'] as int? ?? 0,
      forks: json['forks'] as int? ?? 0,
      language: json['language'] as String?,
      topics: (json['topics'] as List? ?? []).cast<String>(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
      archived: json['archived'] as bool? ?? false,
      isOrganization: json['is_organization'] as bool? ?? false,
      demoUrl: json['demo_url'] as String?,
    );
  }

  bool get hasDemo => demoUrl != null && demoUrl!.isNotEmpty;
}

class ContributedRepository {
  final String fullName;
  final int repoStars;
  final String repoLink;
  final String? repoDescription;
  final List<PortfolioPullRequest> pullRequests;

  const ContributedRepository({
    required this.fullName,
    required this.repoStars,
    required this.repoLink,
    required this.repoDescription,
    required this.pullRequests,
  });

  factory ContributedRepository.fromJson(
      String fullName, Map<String, dynamic> json) {
    final pullRequests = (json['prs'] as List? ?? [])
        .map((pr) => PortfolioPullRequest.fromJson(pr as Map<String, dynamic>))
        .toList();

    // Newest contribution first.
    pullRequests.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      if (aDate == null || bDate == null) return 0;
      return bDate.compareTo(aDate);
    });

    return ContributedRepository(
      fullName: fullName,
      repoStars: json['repo_stars'] as int? ?? 0,
      repoLink: json['repo_link'] as String? ?? 'https://github.com/$fullName',
      repoDescription: json['repo_description'] as String?,
      pullRequests: pullRequests,
    );
  }

  String get name => fullName.split('/').last;

  String get owner => fullName.split('/').first;

  Map<String, int> get pullRequestStates {
    final states = <String, int>{};
    for (final pullRequest in pullRequests) {
      states[pullRequest.state] = (states[pullRequest.state] ?? 0) + 1;
    }
    return states;
  }
}

class PortfolioPullRequest {
  final String title;
  final String link;
  final String state;
  final DateTime? createdAt;
  final DateTime? mergedAt;

  const PortfolioPullRequest({
    required this.title,
    required this.link,
    required this.state,
    required this.createdAt,
    required this.mergedAt,
  });

  factory PortfolioPullRequest.fromJson(Map<String, dynamic> json) {
    return PortfolioPullRequest(
      title: json['title'] as String? ?? 'Untitled',
      link: json['link'] as String? ?? '',
      state: (json['state'] as String? ?? 'unknown').toLowerCase(),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      mergedAt: DateTime.tryParse(json['merged_at'] as String? ?? ''),
    );
  }
}
