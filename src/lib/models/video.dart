import 'author.dart';
class Videos {
  String? title;
  String? cover;
  String? play;
  int? createTime;
  Author? author;
  int? isTop;

  Videos(
      {
      this.title,
      this.cover,
      this.play,
      this.createTime,
      this.author,
      this.isTop});

  Videos.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    cover = json['cover'];
    play = json['play'];
    createTime = json['create_time'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    isTop = json['is_top'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['play'] = this.play;
    data['create_time'] = this.createTime;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    data['is_top'] = this.isTop;
    return data;
  }
}
