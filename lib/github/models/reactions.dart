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
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["url"] = url;
        _data["total_count"] = totalCount;
        _data["+1"] = plusOne;
        _data["-1"] = minusOne;
        _data["laugh"] = laugh;
        _data["hooray"] = hooray;
        _data["confused"] = confused;
        _data["heart"] = heart;
        _data["rocket"] = rocket;
        _data["eyes"] = eyes;
        return _data;
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
