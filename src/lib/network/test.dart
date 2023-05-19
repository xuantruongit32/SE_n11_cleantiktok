import 'network.dart';
import '../models/video.dart';

void main() async {
  try {
    ApiService apiService = ApiService(channel: '@dangthuhaf');
    List<Video> videoList = await apiService.fetchVideos();

    // Do further operations with the videoList
    print('Total videos: ${videoList.length}');
    for (var video in videoList) {
      print('Video title: ${video.title}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

