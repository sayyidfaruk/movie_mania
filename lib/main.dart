import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviemania/screens/splash_screen.dart';
import 'screens/watch_list_screen.dart';
import 'screens/watched_movies_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/watchlist': (context) => WatchListScreen(),
        '/watched': (context) => WatchedMoviesScreen(),
      },
    );
  }
}
