import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnimeWatchCard extends StatefulWidget {
  final String animeEpisodeId;
  final AnimeInfo animeInfo;
  final bool showAnimeSearch;
  const AnimeWatchCard({
    Key? key,
    required this.animeEpisodeId,
    required this.animeInfo,
    this.showAnimeSearch = true,
  }) : super(key: key);

  @override
  State<AnimeWatchCard> createState() => _AnimeWatchCardState();
}

class _AnimeWatchCardState extends State<AnimeWatchCard> {
  Future<EpisodeLinks> getSources() async {
    try {
      final response = await http.get(
        animeEpisodes(
          widget.animeEpisodeId,
          baseUrl: widget.showAnimeSearch ? gogoAnime : flixhq,
          mediaId: widget.animeInfo.id,
        ),
      );

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
      semanticContainer: false,
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
                    final encodedUrl =
                        Uri.encodeComponent(episodeLinks.sources[i].url);
                    final encodedTitle =
                        Uri.encodeComponent(widget.animeInfo.animeTitle);
                    AppRoutes.router.navigateTo(
                      context,
                      '/video_player?url=$encodedUrl&title=$encodedTitle',
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
