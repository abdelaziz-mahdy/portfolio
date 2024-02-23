import 'package:portfolio/github/models/pull_request.dart';
import 'package:portfolio/github/models/reactions.dart';
import 'package:portfolio/github/models/user.dart';

class GithubIssue {
    String? url;
    String? repositoryUrl;
    String? labelsUrl;
    String? commentsUrl;
    String? eventsUrl;
    String? htmlUrl;
    int? id;
    String? nodeId;
    int? number;
    String? title;
    User? user;
    List<dynamic>? labels;
    String? state;
    bool? locked;
    dynamic assignee;
    List<dynamic>? assignees;
    dynamic milestone;
    int? comments;
    String? createdAt;
    String? updatedAt;
    String? closedAt;
    String? authorAssociation;
    dynamic activeLockReason;
    bool? draft;
    PullRequest? pullRequest;
    dynamic body;
    Reactions? reactions;
    String? timelineUrl;
    dynamic performedViaGithubApp;
    dynamic stateReason;
    double? score;

    GithubIssue({this.url, this.repositoryUrl, this.labelsUrl, this.commentsUrl, this.eventsUrl, this.htmlUrl, this.id, this.nodeId, this.number, this.title, this.user, this.labels, this.state, this.locked, this.assignee, this.assignees, this.milestone, this.comments, this.createdAt, this.updatedAt, this.closedAt, this.authorAssociation, this.activeLockReason, this.draft, this.pullRequest, this.body, this.reactions, this.timelineUrl, this.performedViaGithubApp, this.stateReason, this.score});

    GithubIssue.fromJson(Map<String, dynamic> json) {
        url = json["url"];
        repositoryUrl = json["repository_url"];
        labelsUrl = json["labels_url"];
        commentsUrl = json["comments_url"];
        eventsUrl = json["events_url"];
        htmlUrl = json["html_url"];
        id = json["id"];
        nodeId = json["node_id"];
        number = json["number"];
        title = json["title"];
        user = json["user"] == null ? null : User.fromJson(json["user"]);
        labels = json["labels"] ?? [];
        state = json["state"];
        locked = json["locked"];
        assignee = json["assignee"];
        assignees = json["assignees"] ?? [];
        milestone = json["milestone"];
        comments = json["comments"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
        closedAt = json["closed_at"];
        authorAssociation = json["author_association"];
        activeLockReason = json["active_lock_reason"];
        draft = json["draft"];
        pullRequest = json["pull_request"] == null ? null : PullRequest.fromJson(json["pull_request"]);
        body = json["body"];
        reactions = json["reactions"] == null ? null : Reactions.fromJson(json["reactions"]);
        timelineUrl = json["timeline_url"];
        performedViaGithubApp = json["performed_via_github_app"];
        stateReason = json["state_reason"];
        score = json["score"];
    }

    static List<GithubIssue> fromList(List<Map<String, dynamic>> list) {
        return list.map((map) => GithubIssue.fromJson(map)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["url"] = url;
        _data["repository_url"] = repositoryUrl;
        _data["labels_url"] = labelsUrl;
        _data["comments_url"] = commentsUrl;
        _data["events_url"] = eventsUrl;
        _data["html_url"] = htmlUrl;
        _data["id"] = id;
        _data["node_id"] = nodeId;
        _data["number"] = number;
        _data["title"] = title;
        if(user != null) {
            _data["user"] = user?.toJson();
        }
        if(labels != null) {
            _data["labels"] = labels;
        }
        _data["state"] = state;
        _data["locked"] = locked;
        _data["assignee"] = assignee;
        if(assignees != null) {
            _data["assignees"] = assignees;
        }
        _data["milestone"] = milestone;
        _data["comments"] = comments;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        _data["closed_at"] = closedAt;
        _data["author_association"] = authorAssociation;
        _data["active_lock_reason"] = activeLockReason;
        _data["draft"] = draft;
        if(pullRequest != null) {
            _data["pull_request"] = pullRequest?.toJson();
        }
        _data["body"] = body;
        if(reactions != null) {
            _data["reactions"] = reactions?.toJson();
        }
        _data["timeline_url"] = timelineUrl;
        _data["performed_via_github_app"] = performedViaGithubApp;
        _data["state_reason"] = stateReason;
        _data["score"] = score;
        return _data;
    }

    GithubIssue copyWith({
        String? url,
        String? repositoryUrl,
        String? labelsUrl,
        String? commentsUrl,
        String? eventsUrl,
        String? htmlUrl,
        int? id,
        String? nodeId,
        int? number,
        String? title,
        User? user,
        List<dynamic>? labels,
        String? state,
        bool? locked,
        dynamic assignee,
        List<dynamic>? assignees,
        dynamic milestone,
        int? comments,
        String? createdAt,
        String? updatedAt,
        String? closedAt,
        String? authorAssociation,
        dynamic activeLockReason,
        bool? draft,
        PullRequest? pullRequest,
        dynamic body,
        Reactions? reactions,
        String? timelineUrl,
        dynamic performedViaGithubApp,
        dynamic stateReason,
        double? score,
    }) => GithubIssue(
        url: url ?? this.url,
        repositoryUrl: repositoryUrl ?? this.repositoryUrl,
        labelsUrl: labelsUrl ?? this.labelsUrl,
        commentsUrl: commentsUrl ?? this.commentsUrl,
        eventsUrl: eventsUrl ?? this.eventsUrl,
        htmlUrl: htmlUrl ?? this.htmlUrl,
        id: id ?? this.id,
        nodeId: nodeId ?? this.nodeId,
        number: number ?? this.number,
        title: title ?? this.title,
        user: user ?? this.user,
        labels: labels ?? this.labels,
        state: state ?? this.state,
        locked: locked ?? this.locked,
        assignee: assignee ?? this.assignee,
        assignees: assignees ?? this.assignees,
        milestone: milestone ?? this.milestone,
        comments: comments ?? this.comments,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        closedAt: closedAt ?? this.closedAt,
        authorAssociation: authorAssociation ?? this.authorAssociation,
        activeLockReason: activeLockReason ?? this.activeLockReason,
        draft: draft ?? this.draft,
        pullRequest: pullRequest ?? this.pullRequest,
        body: body ?? this.body,
        reactions: reactions ?? this.reactions,
        timelineUrl: timelineUrl ?? this.timelineUrl,
        performedViaGithubApp: performedViaGithubApp ?? this.performedViaGithubApp,
        stateReason: stateReason ?? this.stateReason,
        score: score ?? this.score,
    );
}
