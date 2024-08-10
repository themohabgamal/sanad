import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shimmer/shimmer.dart';

class YTVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const YTVideoPlayer({super.key, required this.videoUrl});

  @override
  State<YTVideoPlayer> createState() => _YTVideoPlayerState();
}

class _YTVideoPlayerState extends State<YTVideoPlayer> {
  late PodPlayerController _controller;
  late String videoTitle;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  Future<void> initializeController() async {
    await _initializeVideo(widget.videoUrl);
  }

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      var youtubeExplode = YoutubeExplode();
      var videoId = VideoId(videoUrl);

      // Fetch video information
      var video = await youtubeExplode.videos.get(videoId);
      videoTitle = video.title;

      // Fetch video stream URL
      var manifest =
          await youtubeExplode.videos.streamsClient.getManifest(videoId);
      var streamInfo = manifest.muxed.withHighestBitrate();
      var streamUrl = streamInfo.url.toString();

      _controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(streamUrl),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
        ),
      )..initialise().then((_) {
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          print("Error initializing video player: $error");
          setState(() {
            isLoading = false;
          });
        });

      youtubeExplode.close();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error initializing video player: $e");
    }
  }

  Future<void> _changeVideo(String newVideoUrl) async {
    setState(() {
      isLoading = true;
    });
    _controller.dispose();
    await _initializeVideo(newVideoUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  videoTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Cairo",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  child: PodVideoPlayer(controller: _controller),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  _changeVideo("https://www.youtube.com/watch?v=LypmSqQyuXo");
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "درس أخر",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Cairo",
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
