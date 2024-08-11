import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimeListScreen extends StatelessWidget {
  final List<AnimeSearchResult> results;
  final bool showAnimeSearch;
  const AnimeListScreen({
    Key? key,
    required this.results,
    this.showAnimeSearch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: (results.isNotEmpty)
          ? ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                final animeSearchResult = results[i];
                return ListTile(
                  key: ValueKey(
                      '${animeSearchResult.id}-${DateTime.now().millisecondsSinceEpoch}'),
                  enableFeedback: true,
                  isThreeLine: true,
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(animeSearchResult.img),
                    radius: 33,
                  ),
                  title: Text(
                    animeSearchResult.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    animeSearchResult.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Colors.purpleAccent,
                  ),
                  onTap: () {
                    AppRoutes.router.navigateTo(
                      context,
                      "/anime_info/${Uri.encodeComponent(animeSearchResult.id)}/$showAnimeSearch",
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text(
                "No anime with the name provided.",
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
    );
  }
}
