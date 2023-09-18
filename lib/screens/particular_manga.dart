import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MangaInfoScreen extends StatelessWidget {
  const MangaInfoScreen({
    super.key,
    required this.mangaId,
  });
  final String mangaId;

  @override
  Widget build(BuildContext context) {
    Future<MangaInfo> fetchMangaInfo() async {
      try {
        final uri = mangaDexGetInfo(mangaId);
        final response = await http.get(uri);
        if (response.statusCode != 200) {
          throw http.ClientException(response.reasonPhrase.toString());
        }

        return MangaInfo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } catch (_) {
        rethrow;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder(
        future: fetchMangaInfo(),
        builder: (context, snapshot) {
          final error = snapshot.error;
          final data = snapshot.data;

          if (error != null) {
            return Center(
              child: Text(error.toString()),
            );
          }

          if (data != null) {
            final mangaInfo = data;
            return ListView(
              children: [
                Image.network(
                  mangaInfo.image,
                  fit: BoxFit.fitHeight,
                  height: 500,
                ),
                const SizedBox(height: 10),
                Text(
                  mangaInfo.title.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 33,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Status: ${mangaInfo.status},",
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Type: ${mangaInfo.genres},",
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "OtherNames: ${mangaInfo.altTitles.where((element) => element.en != null).map((e) => e.en)}",
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (mangaInfo.description?.en != null)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "Description: ${mangaInfo.description?.en}",
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ...mangaInfo.chapters.map(
                  (chapter) => ListTile(
                    leading: const Icon(
                      CupertinoIcons.book_circle_fill,
                      color: Colors.white,
                      size: 13.5,
                    ),
                    title: Text(
                      chapter.title.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      chapter.volumeNumber != null
                          ? "Volume: ${chapter.volumeNumber} Chapter: ${chapter.chapterNumber}"
                          : chapter.chapterNumber == null ? "Chapter: ${chapter.chapterNumber}" : "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/manga_reader",
                        arguments: chapter.id,
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return Image.asset("assets/lottie/animation_lmp6v43j_small.gif");
        },
      ),
    );
  }
}
