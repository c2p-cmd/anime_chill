import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' show document;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoActivityIndicator, CupertinoIcons;
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

  late final _scaffoldMessenger = ScaffoldMessenger.of(context);

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const BackButton(),
            IconButton(
              onPressed: () async {
                if (kIsWeb) {
                  _scaffoldMessenger.hideCurrentSnackBar();
                  final clipboardDate = ClipboardData(text: widget.url);
                  await Clipboard.setData(clipboardDate);
                  final snackBar = SnackBar(
                    duration: const Duration(seconds: 1),
                    content: const Text("Copied!"),
                    action: SnackBarAction(
                      label: "Okay",
                      onPressed: _scaffoldMessenger.hideCurrentSnackBar,
                    ),
                  );
                  _scaffoldMessenger.showSnackBar(snackBar);
                  return;
                }

                Share.shareUri(Uri.parse(widget.url));
              },
              icon: const Icon(CupertinoIcons.share_up),
            ),
            IconButton(
              onPressed: () {
                launchUrlString(
                  widget.url,
                  mode: LaunchMode.inAppBrowserView,
                  webOnlyWindowName: widget.title,
                );
              },
              icon: const Icon(CupertinoIcons.compass_fill),
            ),
          ],
        ),
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
          final copyButton = OptionItem(
            onTap: () async {
              _scaffoldMessenger.hideCurrentSnackBar();
              final clipboardDate = ClipboardData(text: widget.url);
              await Clipboard.setData(clipboardDate);
              final snackBar = SnackBar(
                duration: const Duration(seconds: 1),
                content: const Text("Copied!"),
                action: SnackBarAction(
                  label: "Okay",
                  onPressed: _scaffoldMessenger.hideCurrentSnackBar,
                ),
              );
              _scaffoldMessenger.showSnackBar(snackBar);
            },
            iconData: Icons.content_copy_rounded,
            title: "Copy link",
          );

          if (kIsWeb == false) {
            return [
              copyButton,
            ];
          }

          return [
            copyButton,
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
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
        ],
      );
    });
  }
}
