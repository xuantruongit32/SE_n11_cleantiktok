class Author {
  String? uniqueId;
  String? nickname;
  String? avatar;

  Author({this.uniqueId, this.nickname, this.avatar});

  Author.fromJson(Map<String, dynamic> json) {
    uniqueId = json['unique_id'];
    nickname = json['nickname'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unique_id'] = this.uniqueId;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    return data;
  }
}

