import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'filters.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    DRAMATIC_MATRIX,
    NOIR_MATRIX,
    VIVID_MATRIX,
    MONO_MATRIX
  ];
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.asset("assets/videos/Nature.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Filters"),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: PageView.builder(
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        return ColorFiltered(
                          colorFilter: ColorFilter.matrix(filters[index]),
                          child: VideoPlayer(_controller),
                        );
                      }),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // pause
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // play
              _controller.play();
            }
          });
        },
        // icon
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
