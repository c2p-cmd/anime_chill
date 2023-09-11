import 'dart:convert';
import 'dart:html';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/screens/better_video_player.dart';
import 'package:anime_chill/screens/video_player_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnimeWatchCard extends StatelessWidget {
  final String animeEpisodeId;
  final AnimeInfo animeInfo;
  const AnimeWatchCard({
    Key? key,
    required this.animeEpisodeId,
    required this.animeInfo,
  }) : super(key: key);

  Future<EpisodeLinks> getSources() async {
    try {
      final response =
          await http.get(animeEpisodes(animeEpisodeId, defaultBaseUrl));

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
    return Card(
      child: FutureBuilder(
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
              itemCount: episodeLinks.sources.length + 1,
              itemBuilder: (ctx, i) {
                if (i == episodeLinks.sources.length) {
                  return CupertinoButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close),
                        Text(
                          "Close",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                }
                return CupertinoButton(
                  child: Text(
                    episodeLinks.sources[i].quality,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xfff802ff),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          if (kIsWeb) {
                            return WebVideoPlayer(
                              url: episodeLinks.sources[i].url,
                              title: animeInfo.animeTitle,
                            );
                          }

                          return BetterVideoPlayer(
                            url: episodeLinks.sources[i].url,
                            title: animeInfo.animeTitle,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
