import 'package:portfolio/github/models/owner.dart';

class GithubRepository {
  int? id;
  String? nodeId;
  String? name;
  String? fullName;
  bool? private;
  Owner? owner;
  String? htmlUrl;
  dynamic description;
  bool? fork;
  String? url;
  String? forksUrl;
  String? keysUrl;
  String? collaboratorsUrl;
  String? teamsUrl;
  String? hooksUrl;
  String? issueEventsUrl;
  String? eventsUrl;
  String? assigneesUrl;
  String? branchesUrl;
  String? tagsUrl;
  String? blobsUrl;
  String? gitTagsUrl;
  String? gitRefsUrl;
  String? treesUrl;
  String? statusesUrl;
  String? languagesUrl;
  String? stargazersUrl;
  String? contributorsUrl;
  String? subscribersUrl;
  String? subscriptionUrl;
  String? commitsUrl;
  String? gitCommitsUrl;
  String? commentsUrl;
  String? issueCommentUrl;
  String? contentsUrl;
  String? compareUrl;
  String? mergesUrl;
  String? archiveUrl;
  String? downloadsUrl;
  String? issuesUrl;
  String? pullsUrl;
  String? milestonesUrl;
  String? notificationsUrl;
  String? labelsUrl;
  String? releasesUrl;
  String? deploymentsUrl;
  String? createdAt;
  String? updatedAt;
  String? pushedAt;
  String? gitUrl;
  String? sshUrl;
  String? cloneUrl;
  String? svnUrl;
  dynamic homepage;
  int? size;
  int? stargazersCount;
  int? watchersCount;
  String? language;
  bool? hasIssues;
  bool? hasProjects;
  bool? hasDownloads;
  bool? hasWiki;
  bool? hasPages;
  bool? hasDiscussions;
  int? forksCount;
  dynamic mirrorUrl;
  bool? archived;
  bool? disabled;
  int? openIssuesCount;
  dynamic license;
  bool? allowForking;
  bool? isTemplate;
  bool? webCommitSignoffRequired;
  List<dynamic>? topics;
  String? visibility;
  int? forks;
  int? openIssues;
  int? watchers;
  String? defaultBranch;

  GithubRepository(
      {this.id,
      this.nodeId,
      this.name,
      this.fullName,
      this.private,
      this.owner,
      this.htmlUrl,
      this.description,
      this.fork,
      this.url,
      this.forksUrl,
      this.keysUrl,
      this.collaboratorsUrl,
      this.teamsUrl,
      this.hooksUrl,
      this.issueEventsUrl,
      this.eventsUrl,
      this.assigneesUrl,
      this.branchesUrl,
      this.tagsUrl,
      this.blobsUrl,
      this.gitTagsUrl,
      this.gitRefsUrl,
      this.treesUrl,
      this.statusesUrl,
      this.languagesUrl,
      this.stargazersUrl,
      this.contributorsUrl,
      this.subscribersUrl,
      this.subscriptionUrl,
      this.commitsUrl,
      this.gitCommitsUrl,
      this.commentsUrl,
      this.issueCommentUrl,
      this.contentsUrl,
      this.compareUrl,
      this.mergesUrl,
      this.archiveUrl,
      this.downloadsUrl,
      this.issuesUrl,
      this.pullsUrl,
      this.milestonesUrl,
      this.notificationsUrl,
      this.labelsUrl,
      this.releasesUrl,
      this.deploymentsUrl,
      this.createdAt,
      this.updatedAt,
      this.pushedAt,
      this.gitUrl,
      this.sshUrl,
      this.cloneUrl,
      this.svnUrl,
      this.homepage,
      this.size,
      this.stargazersCount,
      this.watchersCount,
      this.language,
      this.hasIssues,
      this.hasProjects,
      this.hasDownloads,
      this.hasWiki,
      this.hasPages,
      this.hasDiscussions,
      this.forksCount,
      this.mirrorUrl,
      this.archived,
      this.disabled,
      this.openIssuesCount,
      this.license,
      this.allowForking,
      this.isTemplate,
      this.webCommitSignoffRequired,
      this.topics,
      this.visibility,
      this.forks,
      this.openIssues,
      this.watchers,
      this.defaultBranch});

  GithubRepository.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    nodeId = json["node_id"];
    name = json["name"];
    fullName = json["full_name"];
    private = json["private"];
    owner = json["owner"] == null ? null : Owner.fromJson(json["owner"]);
    htmlUrl = json["html_url"];
    description = json["description"];
    fork = json["fork"];
    url = json["url"];
    forksUrl = json["forks_url"];
    keysUrl = json["keys_url"];
    collaboratorsUrl = json["collaborators_url"];
    teamsUrl = json["teams_url"];
    hooksUrl = json["hooks_url"];
    issueEventsUrl = json["issue_events_url"];
    eventsUrl = json["events_url"];
    assigneesUrl = json["assignees_url"];
    branchesUrl = json["branches_url"];
    tagsUrl = json["tags_url"];
    blobsUrl = json["blobs_url"];
    gitTagsUrl = json["git_tags_url"];
    gitRefsUrl = json["git_refs_url"];
    treesUrl = json["trees_url"];
    statusesUrl = json["statuses_url"];
    languagesUrl = json["languages_url"];
    stargazersUrl = json["stargazers_url"];
    contributorsUrl = json["contributors_url"];
    subscribersUrl = json["subscribers_url"];
    subscriptionUrl = json["subscription_url"];
    commitsUrl = json["commits_url"];
    gitCommitsUrl = json["git_commits_url"];
    commentsUrl = json["comments_url"];
    issueCommentUrl = json["issue_comment_url"];
    contentsUrl = json["contents_url"];
    compareUrl = json["compare_url"];
    mergesUrl = json["merges_url"];
    archiveUrl = json["archive_url"];
    downloadsUrl = json["downloads_url"];
    issuesUrl = json["issues_url"];
    pullsUrl = json["pulls_url"];
    milestonesUrl = json["milestones_url"];
    notificationsUrl = json["notifications_url"];
    labelsUrl = json["labels_url"];
    releasesUrl = json["releases_url"];
    deploymentsUrl = json["deployments_url"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    pushedAt = json["pushed_at"];
    gitUrl = json["git_url"];
    sshUrl = json["ssh_url"];
    cloneUrl = json["clone_url"];
    svnUrl = json["svn_url"];
    homepage = json["homepage"];
    size = json["size"];
    stargazersCount = json["stargazers_count"];
    watchersCount = json["watchers_count"];
    language = json["language"];
    hasIssues = json["has_issues"];
    hasProjects = json["has_projects"];
    hasDownloads = json["has_downloads"];
    hasWiki = json["has_wiki"];
    hasPages = json["has_pages"];
    hasDiscussions = json["has_discussions"];
    forksCount = json["forks_count"];
    mirrorUrl = json["mirror_url"];
    archived = json["archived"];
    disabled = json["disabled"];
    openIssuesCount = json["open_issues_count"];
    license = json["license"];
    allowForking = json["allow_forking"];
    isTemplate = json["is_template"];
    webCommitSignoffRequired = json["web_commit_signoff_required"];
    topics = json["topics"] ?? [];
    visibility = json["visibility"];
    forks = json["forks"];
    openIssues = json["open_issues"];
    watchers = json["watchers"];
    defaultBranch = json["default_branch"];
  }

  static List<GithubRepository> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => GithubRepository.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["node_id"] = nodeId;
    data["name"] = name;
    data["full_name"] = fullName;
    data["private"] = private;
    if (owner != null) {
      data["owner"] = owner?.toJson();
    }
    data["html_url"] = htmlUrl;
    data["description"] = description;
    data["fork"] = fork;
    data["url"] = url;
    data["forks_url"] = forksUrl;
    data["keys_url"] = keysUrl;
    data["collaborators_url"] = collaboratorsUrl;
    data["teams_url"] = teamsUrl;
    data["hooks_url"] = hooksUrl;
    data["issue_events_url"] = issueEventsUrl;
    data["events_url"] = eventsUrl;
    data["assignees_url"] = assigneesUrl;
    data["branches_url"] = branchesUrl;
    data["tags_url"] = tagsUrl;
    data["blobs_url"] = blobsUrl;
    data["git_tags_url"] = gitTagsUrl;
    data["git_refs_url"] = gitRefsUrl;
    data["trees_url"] = treesUrl;
    data["statuses_url"] = statusesUrl;
    data["languages_url"] = languagesUrl;
    data["stargazers_url"] = stargazersUrl;
    data["contributors_url"] = contributorsUrl;
    data["subscribers_url"] = subscribersUrl;
    data["subscription_url"] = subscriptionUrl;
    data["commits_url"] = commitsUrl;
    data["git_commits_url"] = gitCommitsUrl;
    data["comments_url"] = commentsUrl;
    data["issue_comment_url"] = issueCommentUrl;
    data["contents_url"] = contentsUrl;
    data["compare_url"] = compareUrl;
    data["merges_url"] = mergesUrl;
    data["archive_url"] = archiveUrl;
    data["downloads_url"] = downloadsUrl;
    data["issues_url"] = issuesUrl;
    data["pulls_url"] = pullsUrl;
    data["milestones_url"] = milestonesUrl;
    data["notifications_url"] = notificationsUrl;
    data["labels_url"] = labelsUrl;
    data["releases_url"] = releasesUrl;
    data["deployments_url"] = deploymentsUrl;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["pushed_at"] = pushedAt;
    data["git_url"] = gitUrl;
    data["ssh_url"] = sshUrl;
    data["clone_url"] = cloneUrl;
    data["svn_url"] = svnUrl;
    data["homepage"] = homepage;
    data["size"] = size;
    data["stargazers_count"] = stargazersCount;
    data["watchers_count"] = watchersCount;
    data["language"] = language;
    data["has_issues"] = hasIssues;
    data["has_projects"] = hasProjects;
    data["has_downloads"] = hasDownloads;
    data["has_wiki"] = hasWiki;
    data["has_pages"] = hasPages;
    data["has_discussions"] = hasDiscussions;
    data["forks_count"] = forksCount;
    data["mirror_url"] = mirrorUrl;
    data["archived"] = archived;
    data["disabled"] = disabled;
    data["open_issues_count"] = openIssuesCount;
    data["license"] = license;
    data["allow_forking"] = allowForking;
    data["is_template"] = isTemplate;
    data["web_commit_signoff_required"] = webCommitSignoffRequired;
    if (topics != null) {
      data["topics"] = topics;
    }
    data["visibility"] = visibility;
    data["forks"] = forks;
    data["open_issues"] = openIssues;
    data["watchers"] = watchers;
    data["default_branch"] = defaultBranch;
    return data;
  }

  GithubRepository copyWith({
    int? id,
    String? nodeId,
    String? name,
    String? fullName,
    bool? private,
    Owner? owner,
    String? htmlUrl,
    dynamic description,
    bool? fork,
    String? url,
    String? forksUrl,
    String? keysUrl,
    String? collaboratorsUrl,
    String? teamsUrl,
    String? hooksUrl,
    String? issueEventsUrl,
    String? eventsUrl,
    String? assigneesUrl,
    String? branchesUrl,
    String? tagsUrl,
    String? blobsUrl,
    String? gitTagsUrl,
    String? gitRefsUrl,
    String? treesUrl,
    String? statusesUrl,
    String? languagesUrl,
    String? stargazersUrl,
    String? contributorsUrl,
    String? subscribersUrl,
    String? subscriptionUrl,
    String? commitsUrl,
    String? gitCommitsUrl,
    String? commentsUrl,
    String? issueCommentUrl,
    String? contentsUrl,
    String? compareUrl,
    String? mergesUrl,
    String? archiveUrl,
    String? downloadsUrl,
    String? issuesUrl,
    String? pullsUrl,
    String? milestonesUrl,
    String? notificationsUrl,
    String? labelsUrl,
    String? releasesUrl,
    String? deploymentsUrl,
    String? createdAt,
    String? updatedAt,
    String? pushedAt,
    String? gitUrl,
    String? sshUrl,
    String? cloneUrl,
    String? svnUrl,
    dynamic homepage,
    int? size,
    int? stargazersCount,
    int? watchersCount,
    String? language,
    bool? hasIssues,
    bool? hasProjects,
    bool? hasDownloads,
    bool? hasWiki,
    bool? hasPages,
    bool? hasDiscussions,
    int? forksCount,
    dynamic mirrorUrl,
    bool? archived,
    bool? disabled,
    int? openIssuesCount,
    dynamic license,
    bool? allowForking,
    bool? isTemplate,
    bool? webCommitSignoffRequired,
    List<dynamic>? topics,
    String? visibility,
    int? forks,
    int? openIssues,
    int? watchers,
    String? defaultBranch,
  }) =>
      GithubRepository(
        id: id ?? this.id,
        nodeId: nodeId ?? this.nodeId,
        name: name ?? this.name,
        fullName: fullName ?? this.fullName,
        private: private ?? this.private,
        owner: owner ?? this.owner,
        htmlUrl: htmlUrl ?? this.htmlUrl,
        description: description ?? this.description,
        fork: fork ?? this.fork,
        url: url ?? this.url,
        forksUrl: forksUrl ?? this.forksUrl,
        keysUrl: keysUrl ?? this.keysUrl,
        collaboratorsUrl: collaboratorsUrl ?? this.collaboratorsUrl,
        teamsUrl: teamsUrl ?? this.teamsUrl,
        hooksUrl: hooksUrl ?? this.hooksUrl,
        issueEventsUrl: issueEventsUrl ?? this.issueEventsUrl,
        eventsUrl: eventsUrl ?? this.eventsUrl,
        assigneesUrl: assigneesUrl ?? this.assigneesUrl,
        branchesUrl: branchesUrl ?? this.branchesUrl,
        tagsUrl: tagsUrl ?? this.tagsUrl,
        blobsUrl: blobsUrl ?? this.blobsUrl,
        gitTagsUrl: gitTagsUrl ?? this.gitTagsUrl,
        gitRefsUrl: gitRefsUrl ?? this.gitRefsUrl,
        treesUrl: treesUrl ?? this.treesUrl,
        statusesUrl: statusesUrl ?? this.statusesUrl,
        languagesUrl: languagesUrl ?? this.languagesUrl,
        stargazersUrl: stargazersUrl ?? this.stargazersUrl,
        contributorsUrl: contributorsUrl ?? this.contributorsUrl,
        subscribersUrl: subscribersUrl ?? this.subscribersUrl,
        subscriptionUrl: subscriptionUrl ?? this.subscriptionUrl,
        commitsUrl: commitsUrl ?? this.commitsUrl,
        gitCommitsUrl: gitCommitsUrl ?? this.gitCommitsUrl,
        commentsUrl: commentsUrl ?? this.commentsUrl,
        issueCommentUrl: issueCommentUrl ?? this.issueCommentUrl,
        contentsUrl: contentsUrl ?? this.contentsUrl,
        compareUrl: compareUrl ?? this.compareUrl,
        mergesUrl: mergesUrl ?? this.mergesUrl,
        archiveUrl: archiveUrl ?? this.archiveUrl,
        downloadsUrl: downloadsUrl ?? this.downloadsUrl,
        issuesUrl: issuesUrl ?? this.issuesUrl,
        pullsUrl: pullsUrl ?? this.pullsUrl,
        milestonesUrl: milestonesUrl ?? this.milestonesUrl,
        notificationsUrl: notificationsUrl ?? this.notificationsUrl,
        labelsUrl: labelsUrl ?? this.labelsUrl,
        releasesUrl: releasesUrl ?? this.releasesUrl,
        deploymentsUrl: deploymentsUrl ?? this.deploymentsUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        pushedAt: pushedAt ?? this.pushedAt,
        gitUrl: gitUrl ?? this.gitUrl,
        sshUrl: sshUrl ?? this.sshUrl,
        cloneUrl: cloneUrl ?? this.cloneUrl,
        svnUrl: svnUrl ?? this.svnUrl,
        homepage: homepage ?? this.homepage,
        size: size ?? this.size,
        stargazersCount: stargazersCount ?? this.stargazersCount,
        watchersCount: watchersCount ?? this.watchersCount,
        language: language ?? this.language,
        hasIssues: hasIssues ?? this.hasIssues,
        hasProjects: hasProjects ?? this.hasProjects,
        hasDownloads: hasDownloads ?? this.hasDownloads,
        hasWiki: hasWiki ?? this.hasWiki,
        hasPages: hasPages ?? this.hasPages,
        hasDiscussions: hasDiscussions ?? this.hasDiscussions,
        forksCount: forksCount ?? this.forksCount,
        mirrorUrl: mirrorUrl ?? this.mirrorUrl,
        archived: archived ?? this.archived,
        disabled: disabled ?? this.disabled,
        openIssuesCount: openIssuesCount ?? this.openIssuesCount,
        license: license ?? this.license,
        allowForking: allowForking ?? this.allowForking,
        isTemplate: isTemplate ?? this.isTemplate,
        webCommitSignoffRequired:
            webCommitSignoffRequired ?? this.webCommitSignoffRequired,
        topics: topics ?? this.topics,
        visibility: visibility ?? this.visibility,
        forks: forks ?? this.forks,
        openIssues: openIssues ?? this.openIssues,
        watchers: watchers ?? this.watchers,
        defaultBranch: defaultBranch ?? this.defaultBranch,
      );
}
