import 'author.dart';
class Videos {
  String? videoId;
  String? title;
  String? cover;
  int? duration;
  int? createTime;
  Author? author;

  Videos(
      {
      this.videoId,
      this.title,
      this.cover,
      this.duration,
      this.createTime,
      this.author,
      });

  Videos.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    title = json['title'];
    cover = json['cover'];
    duration = json['duration'];
    createTime = json['create_time'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['cover'] = this.cover;
    data['duration'] = this.duration;
    data['create_time'] = this.createTime;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}
