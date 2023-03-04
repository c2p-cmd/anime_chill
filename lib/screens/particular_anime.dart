import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/screens/anime_watch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnimeInfoScreen extends StatefulWidget {
  final String animeId;
  const AnimeInfoScreen({
    Key? key,
    required this.animeId,
  }) : super(key: key);

  @override
  State<AnimeInfoScreen> createState() => _AnimeInfoScreenState();
}

class _AnimeInfoScreenState extends State<AnimeInfoScreen> {
  Future<AnimeInfo> fetchAnime() async {
    try {
      final id = widget.animeId;
      final response = await http.get(animeDetails(id));
      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase.toString());
      }
      final jsonDecoded = jsonDecode(utf8.decode(response.bodyBytes));
      return AnimeInfo.fromJson(jsonDecoded);
    } catch (_) {
      rethrow;
    }
  }

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
        child: FutureBuilder(
          future: fetchAnime(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final animeInfo = snapshot.data!;
              final children = [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      image: NetworkImage(animeInfo.animeImg),
                    ),
                  ),
                  height: 500,
                ),
                const SizedBox(height: 10),
                Text(
                  animeInfo.animeTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "Status: ${animeInfo.status},",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Type: ${animeInfo.type},",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "OtherName: ${animeInfo.otherNames}",
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Episode Count: ${animeInfo.totalEpisodes}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ];
              final episodes = animeInfo.episodesList.toList();
              children.addAll(
                List.generate(
                  animeInfo.episodesList.length,
                  (index) {
                    return ListTile(
                      leading: const Icon(
                        CupertinoIcons.tv_fill,
                        color: Colors.white,
                        size: 13.5,
                      ),
                      title: Text(
                        "Episode: ${episodes[index].num}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              child: AnimeWatchCard(
                                animeEpisodeId: episodes[index].id,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
              return ListView(children: children);
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: const LinearProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
