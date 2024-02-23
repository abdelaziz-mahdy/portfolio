class Owner {
    String? login;
    int? id;
    String? nodeId;
    String? avatarUrl;
    String? gravatarId;
    String? url;
    String? htmlUrl;
    String? followersUrl;
    String? followingUrl;
    String? gistsUrl;
    String? starredUrl;
    String? subscriptionsUrl;
    String? organizationsUrl;
    String? reposUrl;
    String? eventsUrl;
    String? receivedEventsUrl;
    String? type;
    bool? siteAdmin;

    Owner({this.login, this.id, this.nodeId, this.avatarUrl, this.gravatarId, this.url, this.htmlUrl, this.followersUrl, this.followingUrl, this.gistsUrl, this.starredUrl, this.subscriptionsUrl, this.organizationsUrl, this.reposUrl, this.eventsUrl, this.receivedEventsUrl, this.type, this.siteAdmin});

    Owner.fromJson(Map<String, dynamic> json) {
        login = json["login"];
        id = json["id"];
        nodeId = json["node_id"];
        avatarUrl = json["avatar_url"];
        gravatarId = json["gravatar_id"];
        url = json["url"];
        htmlUrl = json["html_url"];
        followersUrl = json["followers_url"];
        followingUrl = json["following_url"];
        gistsUrl = json["gists_url"];
        starredUrl = json["starred_url"];
        subscriptionsUrl = json["subscriptions_url"];
        organizationsUrl = json["organizations_url"];
        reposUrl = json["repos_url"];
        eventsUrl = json["events_url"];
        receivedEventsUrl = json["received_events_url"];
        type = json["type"];
        siteAdmin = json["site_admin"];
    }

    static List<Owner> fromList(List<Map<String, dynamic>> list) {
        return list.map((map) => Owner.fromJson(map)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["login"] = login;
        _data["id"] = id;
        _data["node_id"] = nodeId;
        _data["avatar_url"] = avatarUrl;
        _data["gravatar_id"] = gravatarId;
        _data["url"] = url;
        _data["html_url"] = htmlUrl;
        _data["followers_url"] = followersUrl;
        _data["following_url"] = followingUrl;
        _data["gists_url"] = gistsUrl;
        _data["starred_url"] = starredUrl;
        _data["subscriptions_url"] = subscriptionsUrl;
        _data["organizations_url"] = organizationsUrl;
        _data["repos_url"] = reposUrl;
        _data["events_url"] = eventsUrl;
        _data["received_events_url"] = receivedEventsUrl;
        _data["type"] = type;
        _data["site_admin"] = siteAdmin;
        return _data;
    }

    Owner copyWith({
        String? login,
        int? id,
        String? nodeId,
        String? avatarUrl,
        String? gravatarId,
        String? url,
        String? htmlUrl,
        String? followersUrl,
        String? followingUrl,
        String? gistsUrl,
        String? starredUrl,
        String? subscriptionsUrl,
        String? organizationsUrl,
        String? reposUrl,
        String? eventsUrl,
        String? receivedEventsUrl,
        String? type,
        bool? siteAdmin,
    }) => Owner(
        login: login ?? this.login,
        id: id ?? this.id,
        nodeId: nodeId ?? this.nodeId,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        gravatarId: gravatarId ?? this.gravatarId,
        url: url ?? this.url,
        htmlUrl: htmlUrl ?? this.htmlUrl,
        followersUrl: followersUrl ?? this.followersUrl,
        followingUrl: followingUrl ?? this.followingUrl,
        gistsUrl: gistsUrl ?? this.gistsUrl,
        starredUrl: starredUrl ?? this.starredUrl,
        subscriptionsUrl: subscriptionsUrl ?? this.subscriptionsUrl,
        organizationsUrl: organizationsUrl ?? this.organizationsUrl,
        reposUrl: reposUrl ?? this.reposUrl,
        eventsUrl: eventsUrl ?? this.eventsUrl,
        receivedEventsUrl: receivedEventsUrl ?? this.receivedEventsUrl,
        type: type ?? this.type,
        siteAdmin: siteAdmin ?? this.siteAdmin,
    );
}