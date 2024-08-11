import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PopularAnimePage extends StatefulWidget {
  const PopularAnimePage({Key? key}) : super(key: key);

  @override
  State<PopularAnimePage> createState() => _PopularAnimePageState();
}

class _PopularAnimePageState extends State<PopularAnimePage> {
  var showAnime = true;

  Future<List<AnimePopular>> getPopularAnime(String baseUrl) async {
    try {
      final response = await http.get(
        popularAnime(baseUrl: baseUrl),
        headers: {'Content-type': 'application/json; charset=utf-8'},
      );

      if (response.statusCode != 200) {
        throw http.ClientException(response.reasonPhrase.toString());
      }

      final jsonDecoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      )['results'];
      final List<AnimePopular> animeList = List.from(
        jsonDecoded.map((e) => AnimePopular.fromJson(e)),
      );
      return animeList;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Popular ${showAnime ? "Anime" : "Movies"}".toUpperCase(),
        ),
        actions: [
          Switch(
            value: showAnime,
            onChanged: (newValue) {
              setState(() {
                showAnime = newValue;
              });
            },
          ),
        ],
        centerTitle: false,
      ),
      body: SafeArea(
        child: _buildWidget(showAnime),
      ),
    );
  }

  Widget _buildWidget(bool showAnime) {
    return FutureBuilder(
      future: getPopularAnime(showAnime ? gogoAnime : flixhq),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

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
                    AppRoutes.router.navigateTo(
                      context,
                      "/anime_info/${Uri.encodeComponent(currentAnime.id)}/$showAnime",
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
                            loadingBuilder: (context, child, loadingProgress) {
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
    );
  }
}
