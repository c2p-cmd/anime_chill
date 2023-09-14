import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/screens/anime_list.dart';
import 'package:anime_chill/screens/better_video_player.dart';
import 'package:anime_chill/screens/home_popular.dart';
import 'package:anime_chill/screens/home_search.dart';
import 'package:anime_chill/screens/particular_anime.dart';
import 'package:anime_chill/screens/video_player_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anime Chill app",
      theme: ThemeData(
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.deepPurpleAccent,
        ),
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xff131313),
        useMaterial3: true,
        primaryColorDark: Colors.deepPurpleAccent,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.deepPurpleAccent,
        ),
      ),
      routes: {
        '/' : (_) {
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search_circle),
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return const PopularAnimePage();
                default:
                  return const SearchPage();
              }
            },
          );
        },
        '/anime_list_screen' : (context) {
          final routeSettings = ModalRoute.of(context)!.settings;
          final animeList = routeSettings.arguments as List<AnimeSearchResult>;
          return AnimeListScreen(results: animeList);
        },
        '/anime_info': (context) {
          final routeSettings = ModalRoute.of(context)!.settings;
          final animeId = routeSettings.arguments.toString();
          return AnimeInfoScreen(animeId: animeId);
        },
        '/video_player': (context) {
          final routeSettings = ModalRoute.of(context)!.settings;
          final arguments = routeSettings.arguments as List<String>;

          if (kIsWeb) {
            return WebVideoPlayer(
              url: arguments[0],
              title: arguments[1],
            );
          }

          return BetterVideoPlayer(
            url: arguments[0],
            title: arguments[1],
          );
        }
      },
    );
  }
}
