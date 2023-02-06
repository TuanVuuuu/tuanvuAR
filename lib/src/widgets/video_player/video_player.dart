// ignore_for_file: unnecessary_string_escapes

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/components/one_colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(videoPlayerController: _videoPlayerController!);
      setState(() {
        // ignore: avoid_print
        print("Video Player\'s Good to Go");
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: 230,
          width: MediaQuery.of(context).size.width - 40,
          child: _chewieVideoPlayer(),
        ),
      ),
    );
  }

  Widget _chewieVideoPlayer() {
    return _chewieController != null && _videoPlayerController != null
        ? Container(
            decoration: BoxDecoration(color: OneColors.black, borderRadius: BorderRadius.circular(30)),
            child: ClipRRect(borderRadius: BorderRadius.circular(30), child: Chewie(controller: _chewieController!)),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
