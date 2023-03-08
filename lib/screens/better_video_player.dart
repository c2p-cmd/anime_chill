import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetterVideoPlayer extends StatefulWidget {
  final String url;
  const BetterVideoPlayer({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<BetterVideoPlayer> createState() => _BetterVideoPlayerState();
}

class _BetterVideoPlayerState extends State<BetterVideoPlayer> {
  late VideoPlayerController player;
  late CustomVideoPlayerController customVideoPlayerController;

  @override
  void initState() {
    player = VideoPlayerController.network(widget.url)
      ..setVolume(1.0)
      ..initialize().then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: player,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
        placeholderWidget: CupertinoActivityIndicator(),
        deviceOrientationsAfterFullscreen: [
          DeviceOrientation.portraitUp,
        ],
        alwaysShowThumbnailOnVideoPaused: true,
        customVideoPlayerProgressBarSettings:
            CustomVideoPlayerProgressBarSettings(
          progressColor: Colors.deepPurpleAccent,
          bufferedColor: Color(0x5A7C4DFF),
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
        child: CustomVideoPlayer(
          customVideoPlayerController: customVideoPlayerController,
        ),
      ),
    );
  }
}
