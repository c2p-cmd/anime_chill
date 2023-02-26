import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/screens/better_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnimeWatchScreen extends StatelessWidget {
  final String animeEpisodeId;
  const AnimeWatchScreen({
    Key? key,
    required this.animeEpisodeId,
  }) : super(key: key);

  Future<EpisodeLinks> getSources() async {
    try {
      final response = await http.get(animeEpisodes(animeEpisodeId, defaultBaseUrl));
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
                      builder: (_) {
                        return BetterVideoPlayer(
                          url: episodeLinks.sources[i].file,
                        );
                      },
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
