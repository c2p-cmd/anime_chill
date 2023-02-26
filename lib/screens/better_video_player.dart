import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
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
        child: AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: BetterPlayer.network(
            widget.url,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              allowedScreenSleep: false,
              errorBuilder: (ctx, errorText) {
                return Center(
                  child: Text(errorText.toString()),
                );
              },
              controlsConfiguration: const BetterPlayerControlsConfiguration(
                enablePip: false,
                playIcon: CupertinoIcons.play_circle,
                pauseIcon: CupertinoIcons.pause_circle,
                skipForwardIcon: CupertinoIcons.forward_end,
                skipBackIcon: CupertinoIcons.backward_end,
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
          ),
        ),
      ),
    );
  }
}
