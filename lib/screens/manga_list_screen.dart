import 'package:anime_chill/api/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MangaListScreen extends StatelessWidget {
  const MangaListScreen({
    super.key,
    required this.results,
  });
  final List<MangaSearchElement> results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: results.isEmpty
          ? const Center(
              child: Text(
                "No manga with the name provided.",
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                final mangaElement = results[index];

                return ListTile(
                  isThreeLine: true,
                  title: Text(
                    mangaElement.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: const CircleAvatar(
                    foregroundImage: AssetImage("assets/manga-icon.png"),
                    radius: 33,
                  ),
                  subtitle: Text(
                    mangaElement.status?.name.toLowerCase() ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Colors.purpleAccent,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/manga_info",
                      arguments: mangaElement.id,
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(
                height: 10,
              ),
              itemCount: results.length,
            ),
    );
  }
}
