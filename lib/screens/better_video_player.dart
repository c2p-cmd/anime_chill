import 'package:better_player/better_player.dart';
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
  final focusNode = FocusNode();
  final player = BetterPlayerController(
    BetterPlayerConfiguration(
      fit: BoxFit.contain,
      allowedScreenSleep: false,
      errorBuilder: (ctx, errorText) {
        return Center(
          child: Text(errorText.toString()),
        );
      },
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      controlsConfiguration: const BetterPlayerControlsConfiguration(
        enablePip: false,
        playIcon: CupertinoIcons.play_circle,
        pauseIcon: CupertinoIcons.pause_circle,
        fullscreenEnableIcon: CupertinoIcons.fullscreen,
        fullscreenDisableIcon: CupertinoIcons.fullscreen_exit,
        muteIcon: CupertinoIcons.volume_up,
        unMuteIcon: CupertinoIcons.volume_off,
        loadingWidget: CupertinoActivityIndicator(
          radius: 18,
          color: Colors.purpleAccent,
        ),
      ),
    ),
  );

  @override
  void initState() {
    player.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
        child: BetterPlayer(
          controller: player,
        ),
      ),
    );
  }
}
