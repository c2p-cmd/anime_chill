import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const PlayerWidget({
    Key? key,
    required this.videoPlayerController,
  }) : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  var isLoaded = false;
  late ChewieController controller;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future init() async {
    await widget.videoPlayerController.initialize();
    controller = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      allowedScreenSleep: false,
      autoInitialize: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: SafeArea(
          child: Center(
            child: Chewie(
              controller: controller,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: const Center(
          child: CupertinoActivityIndicator(
            color: Colors.white60,
          ),
        ),
      );
    }
  }
}
