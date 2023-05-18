import '../models/video.dart';

class VideoList {
  List<Videos> videos;

  VideoList({required this.videos});

  factory VideoList.fromJson(Map<String, dynamic> json) {
    List<Videos> videos = <Videos>[];
    if (json['data'] != null && json['data']['videos'] != null) {
      json['data']['videos'].forEach((videoData) {
        videos.add(Videos.fromJson(videoData));
      });
    }
    return VideoList(videos: videos);
  }
}

