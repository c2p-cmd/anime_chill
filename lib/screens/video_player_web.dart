import 'dart:js' as js;

import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ColorString on Color {
  String toHexString() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

class WebVideoPlayer extends StatefulWidget {
  final String url, title;
  const WebVideoPlayer({super.key, required this.url, required this.title});

  @override
  State<WebVideoPlayer> createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late final VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    js.context.callMethod("setMetaThemeColor", [Colors.black.toHexString()]);
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            allowFullScreen: true,
            allowPlaybackSpeedChanging: true,
            allowedScreenSleep: false,
          );
        });
      });
  }

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
        appBar: const CupertinoNavigationBar(
          backgroundColor: Colors.black,
          leading: BackButton(),
        ),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Chewie(controller: _chewieController),
                )
              : Row(
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
}
