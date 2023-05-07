import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';

class BetterVideoPlayer extends StatefulWidget {
  final String url;
  final String? title;
  const BetterVideoPlayer({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  @override
  State<BetterVideoPlayer> createState() => _BetterVideoPlayerState();
}

class _BetterVideoPlayerState extends State<BetterVideoPlayer> with AutomaticKeepAliveClientMixin<BetterVideoPlayer> {
  final _focusNode = FocusNode();
  var _playerState = PlayerState.PAUSED;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (keyEvent) async {
            if (keyEvent is KeyUpEvent) {
              if (keyEvent.logicalKey == LogicalKeyboardKey.space) {
                if (_playerState == PlayerState.PAUSED) {
                  setState(() {
                    _playerState = PlayerState.PLAYING;
                  });
                }
                if (_playerState == PlayerState.PLAYING) {
                  setState(() {
                    _playerState = PlayerState.PAUSED;
                  });
                }
              }
            }
          },
          child: Video(
            url: widget.url,
            title: widget.title,

            desiredState: _playerState,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
