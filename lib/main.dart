import 'package:anime_chill/screens/home.dart';
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
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: const Color(0xff131313),
      ),
      home: const HomePage(),
    );
  }
}
