import 'package:flutter/material.dart';
import '../models/video.dart';
import 'playvideo.dart';

class VideoList extends StatelessWidget {
  final List<Videos> videos;

  VideoList({required this.videos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return GestureDetector(
          onTap: () {
            _navigateToVideoDetail(context, video);
          },
          child: ListTile(
            leading: FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder_image.png', // Replace with your placeholder image asset
              image: video.cover ?? '',
              fit: BoxFit.cover,
              width: 72,
              height: 72,
            ),
            title: Text(video.title ?? ''),
            subtitle: Text(video.author?.nickname ?? ''),
          ),
        );
      },
    );
  }

  void _navigateToVideoDetail(BuildContext context, Videos video) {
      String url = video.play ?? "";
      PlayVideo(videoUrl: url);
  }
}

