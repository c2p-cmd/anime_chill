import 'dart:math';

import 'package:anime_chill/api/models.dart';
import 'package:anime_chill/screens/anime_list.dart';
import 'package:anime_chill/screens/home_popular.dart';
import 'package:anime_chill/screens/home_search.dart';
import 'package:anime_chill/screens/particular_anime.dart';
import 'package:anime_chill/screens/video_player.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  AppRoutes.setupRouter();
  setPathUrlStrategy();
  runApp(const App());
}

class AppRoutes {
  static FluroRouter router = FluroRouter();

  static void setupRouter() {
    router.define(
      '/',
      handler: Handler(handlerFunc: (context, params) => const HomeWidget()),
    );

    router.define(
      '/anime_list_screen/:searchAnime',
      handler: Handler(
        handlerFunc: (context, params) {
          final arguments = context?.settings?.arguments;
          final searchAnime = params['searchAnime']?[0] ?? 'true';
          if (arguments == null) return const ErrorPage();
          final animeList = arguments as List<AnimeSearchResult>;
          return AnimeListScreen(
            results: animeList,
            showAnimeSearch: bool.tryParse(searchAnime) ?? true,
          );
        },
      ),
    );

    router.define(
      '/anime_info/:id/:searchAnime',
      handler: Handler(
        handlerFunc: (context, params) {
          debugPrint(context?.mounted.toString());
          final animeId = params['id']?[0];
          final searchAnime = params['searchAnime']?[0] ?? 'true';
          if (animeId == null) return const ErrorPage();
          return AnimeInfoScreen(
            animeId: Uri.decodeComponent(animeId),
            showAnimeSearch: bool.tryParse(searchAnime) ?? true,
            key: ValueKey(Random().nextInt(9999)),
          );
        },
      ),
    );

    router.define(
      '/video_player',
      handler: Handler(
        handlerFunc: (context, params) {
          final url = params['url']?[0];
          final title = params['title']?[0];
          if (url == null || title == null) return const ErrorPage();
          return AnimeVideoPlayer(
            url: Uri.decodeComponent(url),
            title: Uri.decodeComponent(title),
          );
        },
      ),
    );
  }
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
      home: const HomeWidget(),
      onGenerateRoute: AppRoutes.router.generator,
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).popUntil(
              (route) => route.settings.name == "/",
            );
          },
        ),
      ),
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
        title: Text(showAnimeSearch ? "SEARCH ANIME" : "SEARCH MOVIES"),
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
        child: SearchPage(showAnimeSearch),
      ),
    );
  }
}
