import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/screens/anime_list.dart';
import 'package:anime_chill/screens/home_popular.dart';
import 'package:anime_chill/screens/home_search.dart';
import 'package:anime_chill/screens/home_search_manga.dart';
import 'package:anime_chill/screens/manga_list_screen.dart';
import 'package:anime_chill/screens/manga_read_page.dart';
import 'package:anime_chill/screens/particular_anime.dart';
import 'package:anime_chill/screens/particular_manga.dart';
import 'package:anime_chill/screens/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anime Chill app",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
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
        '/': (_) {
          return const HomeWidget();
        },
        '/home': (_) {
          return const HomeWidget();
        },
        '/anime_list_screen': (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          final arguments = routeSettings?.arguments;
          if (routeSettings == null || arguments == null) {
            return const ErrorPage();
          }

          final animeList = arguments as List<AnimeSearchResult>;
          return AnimeListScreen(results: animeList);
        },
        '/manga_list_screen': (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          final arguments = routeSettings?.arguments;
          if (routeSettings == null || arguments == null) {
            return const ErrorPage();
          }

          final mangaList = arguments as List<MangaSearchElement>;
          return MangaListScreen(results: mangaList);
        },
        '/anime_info': (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          final arguments = routeSettings?.arguments;
          if (routeSettings == null || arguments == null) {
            return const ErrorPage();
          }

          final animeId = arguments.toString();
          return AnimeInfoScreen(animeId: animeId);
        },
        '/manga_info': (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          final arguments = routeSettings?.arguments;
          if (routeSettings == null || arguments == null) {
            return const ErrorPage();
          }

          final mangaId = arguments.toString();
          return MangaInfoScreen(mangaId: mangaId);
        },
        "/manga_reader": (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          final arguments = routeSettings?.arguments;
          if (routeSettings == null || arguments == null) {
            return const ErrorPage();
          }

          return MangaReadingPage(
            chapterID: arguments.toString(),
          );
        },
        '/video_player': (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          var arguments = routeSettings?.arguments;
          if (routeSettings == null || arguments == null) {
            return const ErrorPage();
          }
          arguments = arguments as List<String>;

          return AnimeVideoPlayer(
            url: arguments[0],
            title: arguments[1],
          );
        }
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset(
          "assets/lottie/animation_lmoxm8mn.json",
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoTabScaffold(
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
              return const AnimatedSearchPage();
          }
        },
      ),
    );
  }
}

class AnimatedSearchPage extends StatefulWidget {
  const AnimatedSearchPage({super.key});

  @override
  State<AnimatedSearchPage> createState() => _AnimatedSearchPageState();
}

class _AnimatedSearchPageState extends State<AnimatedSearchPage> {
  var showAnimeSearch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showAnimeSearch ? "SEARCH ANIME" : "SEARCH MANGA"),
        actions: [
          Switch(
            value: showAnimeSearch,
            onChanged: (newValue) {
              setState(() {
                showAnimeSearch = newValue;
              });
            },
          ),
        ],
        centerTitle: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 900),
        switchInCurve: Curves.fastEaseInToSlowEaseOut,
        // switchOutCurve: Curves.fastEaseInToSlowEaseOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: showAnimeSearch ? const SearchPage() : const MangaSearchPage(),
      ),
    );
  }
}
