import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  Future<void> saveWatchList(List<dynamic> watchList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('watchList', json.encode(watchList));
  }

  Future<void> saveWatchedMovies(List<dynamic> watchedMovies) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('watchedMovies', json.encode(watchedMovies));
  }

  Future<List<dynamic>> getWatchList() async {
    final prefs = await SharedPreferences.getInstance();
    String? watchListString = prefs.getString('watchList');
    if (watchListString != null) {
      return json.decode(watchListString);
    }
    return [];
  }

  Future<List<dynamic>> getWatchedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    String? watchedMoviesString = prefs.getString('watchedMovies');
    if (watchedMoviesString != null) {
      return json.decode(watchedMoviesString);
    }
    return [];
  }
}
