import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' show document;
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

extension ColorString on Color {
  String toHexString() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

class AnimeVideoPlayer extends StatefulWidget {
  final String url, title;
  const AnimeVideoPlayer({super.key, required this.url, required this.title});

  @override
  State<AnimeVideoPlayer> createState() => _AnimeVideoPlayerState();
}

class _AnimeVideoPlayerState extends State<AnimeVideoPlayer> {
  late final _controller = VideoPlayerController.networkUrl(
    Uri.parse(widget.url),
  )..initialize().then(setChewie);
  late ChewieController _chewieController;

  @override
  void dispose() {
    _chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.black),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: const BackButton(),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Chewie(controller: _chewieController),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Loading... ${_controller.value.hasError ? _controller.value.errorDescription.toString() : ""}",
                    ),
                    const CupertinoActivityIndicator()
                  ],
                ),
        ),
      ),
    );
  }

  FutureOr<dynamic> setChewie(void _) {
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        allowedScreenSleep: false,
        additionalOptions: (BuildContext context) {
          if (kIsWeb == false) {
            return [];
          }

          return [
            if (document.fullscreenElement == null)
              OptionItem(
                onTap: () {
                  document.documentElement?.requestFullscreen();
                },
                iconData: Icons.fullscreen,
                title: "Enter Fullscreen",
              ),
            if (document.fullscreenElement != null)
              OptionItem(
                onTap: () {
                  document.exitFullscreen();
                },
                iconData: Icons.fullscreen_exit,
                title: "Exit Fullscreen",
              ),
          ];
        },
      );
    });
  }
}
