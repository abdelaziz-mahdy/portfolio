class Reactions {
    String? url;
    int? totalCount;
    int? plusOne;
    int? minusOne;
    int? laugh;
    int? hooray;
    int? confused;
    int? heart;
    int? rocket;
    int? eyes;

    Reactions({this.url, this.totalCount, this.plusOne, this.minusOne, this.laugh, this.hooray, this.confused, this.heart, this.rocket, this.eyes});

    Reactions.fromJson(Map<String, dynamic> json) {
        url = json["url"];
        totalCount = json["total_count"];
        plusOne = json["+1"];
        minusOne= json["-1"];
        laugh = json["laugh"];
        hooray = json["hooray"];
        confused = json["confused"];
        heart = json["heart"];
        rocket = json["rocket"];
        eyes = json["eyes"];
    }

    static List<Reactions> fromList(List<Map<String, dynamic>> list) {
        return list.map((map) => Reactions.fromJson(map)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["url"] = url;
        data["total_count"] = totalCount;
        data["+1"] = plusOne;
        data["-1"] = minusOne;
        data["laugh"] = laugh;
        data["hooray"] = hooray;
        data["confused"] = confused;
        data["heart"] = heart;
        data["rocket"] = rocket;
        data["eyes"] = eyes;
        return data;
    }

    Reactions copyWith({
        String? url,
        int? totalCount,
        int? plusOne,
        int? minusOne,
        int? laugh,
        int? hooray,
        int? confused,
        int? heart,
        int? rocket,
        int? eyes,
    }) => Reactions(
        url: url ?? this.url,
        totalCount: totalCount ?? this.totalCount,
        plusOne: plusOne ?? this.plusOne,
        minusOne: minusOne ?? this.minusOne,
        laugh: laugh ?? this.laugh,
        hooray: hooray ?? this.hooray,
        confused: confused ?? this.confused,
        heart: heart ?? this.heart,
        rocket: rocket ?? this.rocket,
        eyes: eyes ?? this.eyes,
    );
}
