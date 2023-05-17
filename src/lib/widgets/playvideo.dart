import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TikTokVideoWidget extends StatefulWidget {
  final String tiktokUrl;

  TikTokVideoWidget({required this.tiktokUrl});

  @override
  _TikTokVideoWidgetState createState() => _TikTokVideoWidgetState();
}

class _TikTokVideoWidgetState extends State<TikTokVideoWidget> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.tiktokUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleVideoPlayback() {
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
      if (_isVideoPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _toggleVideoPlayback,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        if (!_isVideoPlaying)
          Center(
            child: Icon(
              Icons.play_arrow,
              size: 64.0,
              color: Colors.white,
            ),
          ),
        if (_isVideoPlaying)
          Center(
            child: IconButton(
              icon: Icon(
                Icons.pause,
                size: 64.0,
                color: Colors.white,
              ),
              onPressed: _toggleVideoPlayback,
            ),
          ),
      ],
    );
  }
}

