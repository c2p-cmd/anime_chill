import 'package:anime_chill/screens/home_popular.dart';
import 'package:anime_chill/screens/home_search.dart';
import 'package:flutter/cupertino.dart';
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
      home: CupertinoTabScaffold(
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
      ),
    );
  }
}
