import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: controller,
              placeholder: "Enter anime to search for.",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            if (isLoading)
              const Center(
                child: LinearProgressIndicator(),
              ),
            CupertinoButton.filled(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final animeToSearch = controller.text;
                try {
                  final response = await http.get(
                    searchAnime(animeToSearch),
                    headers: {
                      'Content-type': 'application/json; charset=utf-8'
                    },
                  );

                  setState(() {
                    isLoading = false;
                  });

                  if (response.statusCode == 200) {
                    final List<dynamic> jsonDecoded = jsonDecode(
                      utf8.decode(response.bodyBytes),
                    )['results'];
                    final List<AnimeSearchResult> animeList = List.from(
                      jsonDecoded.map((e) => AnimeSearchResult.fromJson(e)),
                    );

                    navigatorState.pushNamed(
                      "/anime_list_screen",
                      arguments: animeList,
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Search"),
                  Icon(CupertinoIcons.arrow_right_circle)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
