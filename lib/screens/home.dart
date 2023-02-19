import 'dart:convert';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/api/secret.dart';
import 'package:anime_chill/screens/anime_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  var isLoading = false;

  late ScaffoldMessengerState scaffoldMessengerState;
  late NavigatorState navigatorState;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    navigatorState = Navigator.of(context);
    scaffoldMessengerState = ScaffoldMessenger.of(context);
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoTextField(
                controller: controller,
                placeholder: "Enter anime to search for.",
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
                      final List<dynamic> jsonDecoded =
                          jsonDecode(utf8.decode(response.bodyBytes));
                      final List<AnimeSearchResult> animeList = List.from(
                          jsonDecoded
                              .map((e) => AnimeSearchResult.fromJson(e)));
                      navigatorState.push(
                        MaterialPageRoute(
                          builder: (ctx) => AnimeListScreen(results: animeList),
                        ),
                      );
                    } else {
                      scaffoldMessengerState.showSnackBar(
                        SnackBar(
                          content: Text(response.reasonPhrase.toString()),
                        ),
                      );
                    }
                  } catch (e) {
                    scaffoldMessengerState.showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text("Search"),
                    Icon(CupertinoIcons.arrow_right_circle)
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
