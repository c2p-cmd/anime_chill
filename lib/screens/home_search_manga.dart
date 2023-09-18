import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MangaSearchPage extends StatefulWidget {
  const MangaSearchPage({Key? key}) : super(key: key);

  @override
  State<MangaSearchPage> createState() => _MangaSearchPageState();
}

class _MangaSearchPageState extends State<MangaSearchPage> {
  final controller = TextEditingController();

  var isLoading = false;

  late final scaffoldMessengerState = ScaffoldMessenger.of(context);
  late final navigatorState = Navigator.of(context);

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/manga-img.png",
              height: 200,
              fit: BoxFit.fitHeight,
            ),
            CupertinoTextField(
              controller: controller,
              placeholder: "Enter a manga to search for.",
              style: const TextStyle(
                color: Colors.white,
              ),
              enabled: !isLoading,
            ),
            if (isLoading)
              const Center(
                child: LinearProgressIndicator(),
              ),
            CupertinoButton(
              onPressed: () async {
                if (isLoading) return;

                setState(() {
                  isLoading = true;
                });
                final mangaToSearch = controller.text;
                try {
                  final response = await http.get(
                    mangaDexSearch(mangaToSearch),
                    headers: {
                      'Content-type': 'application/json; charset=utf-8'
                    },
                  );

                  setState(() {
                    isLoading = false;
                  });

                  if (response.statusCode == 200) {
                    final responseBody = utf8.decode(response.bodyBytes);
                    final List<dynamic> jsonDecoded = jsonDecode(
                      responseBody,
                    )['results'];
                    final List<MangaSearchElement> mangaList = List.from(
                      jsonDecoded.map((e) => MangaSearchElement.fromJson(e)),
                    );

                    navigatorState.pushNamed(
                      "/manga_list_screen",
                      arguments: mangaList,
                    );
                  } else {
                    scaffoldMessengerState.showSnackBar(
                      SnackBar(
                        content: Text(
                          response.reasonPhrase.toString(),
                          style: const TextStyle(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  scaffoldMessengerState.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                        style: const TextStyle(
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.5),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Search"),
                    Icon(CupertinoIcons.arrow_right_circle)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
