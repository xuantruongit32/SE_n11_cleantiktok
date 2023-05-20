import 'package:flutter/material.dart';
import '../models/video.dart';
import 'playvideo.dart';

class VideoList extends StatefulWidget {
  final List<Video> videos;

  VideoList({required this.videos});

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  SortingOption _sortingOption = SortingOption.NewerToOlder;

  @override
  Widget build(BuildContext context) {
    List<Video> sortedVideos = _sortVideos(widget.videos);

    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Sort by:'),
                SizedBox(width: 10),
                DropdownButton<SortingOption>(
                  value: _sortingOption,
                  onChanged: (SortingOption? newValue) {
                    setState(() {
                      _sortingOption = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: SortingOption.NewerToOlder,
                      child: Text('Newer to Older'),
                    ),
                    DropdownMenuItem(
                      value: SortingOption.OlderToNewer,
                      child: Text('Older to Newer'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedVideos.length,
              itemBuilder: (context, index) {
                final video = sortedVideos[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToVideoDetail(context, video);
                  },
                  child: Card(
                    child: ListTile(
                      leading: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder_image.png',
                        image: video.cover ?? '',
                        fit: BoxFit.cover,
                        width: 72,
                        height: 72,
                      ),
                      title: Text(video.title ?? ''),
                      subtitle: Text(video.author?.nickname ?? ''),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Video> _sortVideos(List<Video> videos) {
    switch (_sortingOption) {
      case SortingOption.NewerToOlder:
        return List.from(videos)..sort((a, b) => (b.createTime ?? 0).compareTo(a.createTime ?? 0));
      case SortingOption.OlderToNewer:
        return List.from(videos)..sort((a, b) => (a.createTime ?? 0).compareTo(b.createTime ?? 0));
    }
  }

  void _navigateToVideoDetail(BuildContext context, Video video) {
    String url = video.play ?? "";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayVideo(videoUrl: url),
      ),
    );
  }
}

enum SortingOption {
  NewerToOlder,
  OlderToNewer,
}

