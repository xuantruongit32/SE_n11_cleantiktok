import 'video.dart';
class Autogenerated {
  int? code;
  String? msg;
  double? processedTime;
  Data? data;

  Autogenerated({this.code, this.msg, this.processedTime, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    processedTime = json['processed_time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['processed_time'] = this.processedTime;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Video>? videos;
  String? cursor;
  bool? hasMore;

  Data({this.videos, this.cursor, this.hasMore});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = <Video>[];
      json['videos'].forEach((v) {
        videos!.add(new Video.fromJson(v));
      });
    }
    cursor = json['cursor'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['cursor'] = this.cursor;
    data['hasMore'] = this.hasMore;
    return data;
  }
}

