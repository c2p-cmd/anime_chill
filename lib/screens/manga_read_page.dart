import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MangaReadingPage extends StatefulWidget {
  const MangaReadingPage({
    super.key,
    required this.chapterID,
  });
  final String chapterID;

  @override
  State<MangaReadingPage> createState() => _MangaReadingPageState();
}

class _MangaReadingPageState extends State<MangaReadingPage> {
  Future<List<MangaPages>> fetchPages() async {
    try {
      final response = await http.get(mangaDexRead(widget.chapterID));
      if (response.statusCode != 200) {
        throw http.ClientException(response.reasonPhrase.toString());
      }

      final List<dynamic> mangaPagesList =
          jsonDecode(utf8.decode(response.bodyBytes));

      return List.from(mangaPagesList.map((e) => MangaPages.fromJson(e)));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final width = size.width;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, inn) {
          return [
            const SliverAppBar(
              leading: BackButton(),
            ),
          ];
        },
        body: FutureBuilder(
          future: fetchPages(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            final error = snapshot.error;

            if (error != null) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (data != null) {
              final pages = data;
              return PageView.builder(
                itemBuilder: (context, index) {
                  final currentPage = pages[index];

                  return SingleChildScrollView(
                    child: Image.network(
                      currentPage.img,
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
