import 'dart:convert';

import 'package:anime_chill/api/secret.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../api/models.dart';

class PopularAnimePage extends StatefulWidget {
  const PopularAnimePage({Key? key}) : super(key: key);

  @override
  State<PopularAnimePage> createState() => _PopularAnimePageState();
}

class _PopularAnimePageState extends State<PopularAnimePage> {
  Future<List<AnimePopular>> getPopularAnime() async {
    try {
      final response = await http.get(
        popularAnime(defaultBaseUrl),
        headers: {'Content-type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode != 200) {
        throw http.ClientException(response.reasonPhrase.toString());
      }

      final jsonDecoded =
          jsonDecode(utf8.decode(response.bodyBytes))['results'];
      final List<AnimePopular> animeList =
          List.from(jsonDecoded.map((e) => AnimePopular.fromJson(e)));
      return animeList;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: getPopularAnime(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(
                child: Text(snapshot.data.toString()),
              );
            }

            final animeResults = snapshot.data!;
            return Center(
              child: GridView.builder(
                itemCount: animeResults.length,
                itemBuilder: (context, index) {
                  final currentAnime = animeResults[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/anime_info",
                        arguments: currentAnime.id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              currentAnime.img,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return CircularProgressIndicator(
                                  value: loadingProgress.cumulativeBytesLoaded
                                      .toDouble(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentAnime.title,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.7,
                ),
              ),
            );
          }

          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}
