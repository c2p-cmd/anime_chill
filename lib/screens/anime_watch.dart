import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/screens/video_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class AnimeWatchScreen extends StatelessWidget {
  final String animeEpisodeId;
  const AnimeWatchScreen({
    Key? key,
    required this.animeEpisodeId,
  }) : super(key: key);

  Future<EpisodeLinks> getSources() async {
    try {
      final response = await http.get(animeEpisodes(animeEpisodeId));
      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase.toString());
      }

      return EpisodeLinks.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSources(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 33,
              color: Colors.white,
            ),
          );
        }

        if (snapshot.hasData) {
          final episodeLinks = snapshot.data!;
          return ListView.builder(
            itemCount: episodeLinks.sources.length,
            itemBuilder: (ctx, i) {
              final networkController = VideoPlayerController.network(
                episodeLinks.sources[i].file,
                videoPlayerOptions: VideoPlayerOptions(
                  allowBackgroundPlayback: true,
                ),
              );

              return CupertinoButton(
                child: Text(
                  "Source $i",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerWidget(
                        videoPlayerController: networkController,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        return const CupertinoActivityIndicator();
      },
    );
  }
}
