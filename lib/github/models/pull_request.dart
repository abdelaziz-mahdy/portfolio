

class PullRequest {
    String? url;
    String? htmlUrl;
    String? diffUrl;
    String? patchUrl;
    dynamic mergedAt;

    PullRequest({this.url, this.htmlUrl, this.diffUrl, this.patchUrl, this.mergedAt});

    PullRequest.fromJson(Map<String, dynamic> json) {
        url = json["url"];
        htmlUrl = json["html_url"];
        diffUrl = json["diff_url"];
        patchUrl = json["patch_url"];
        mergedAt = json["merged_at"];
    }

    static List<PullRequest> fromList(List<Map<String, dynamic>> list) {
        return list.map((map) => PullRequest.fromJson(map)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["url"] = url;
        data["html_url"] = htmlUrl;
        data["diff_url"] = diffUrl;
        data["patch_url"] = patchUrl;
        data["merged_at"] = mergedAt;
        return data;
    }

    PullRequest copyWith({
        String? url,
        String? htmlUrl,
        String? diffUrl,
        String? patchUrl,
        dynamic mergedAt,
    }) => PullRequest(
        url: url ?? this.url,
        htmlUrl: htmlUrl ?? this.htmlUrl,
        diffUrl: diffUrl ?? this.diffUrl,
        patchUrl: patchUrl ?? this.patchUrl,
        mergedAt: mergedAt ?? this.mergedAt,
    );
}
