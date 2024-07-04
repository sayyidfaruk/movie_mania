import 'package:flutter/material.dart';
import 'package:moviemania/services/storage_service.dart';

class WatchedMoviesScreen extends StatefulWidget {
  @override
  _WatchedMoviesScreenState createState() => _WatchedMoviesScreenState();
}

class _WatchedMoviesScreenState extends State<WatchedMoviesScreen> {
  final StorageService storageService = StorageService();
  List<dynamic> watchedMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchWatchedMovies();
  }

  void _fetchWatchedMovies() async {
    List<dynamic> fetchedWatchedMovies = await storageService.getWatchedMovies();
    setState(() {
      watchedMovies = fetchedWatchedMovies;
    });
  }

  void removeFromWatchedMovies(dynamic movie) async {
    List<dynamic> updatedWatchedMovies = watchedMovies.where((item) => item['id'] != movie['id']).toList();
    await storageService.saveWatchedMovies(updatedWatchedMovies);
    setState(() {
      watchedMovies = updatedWatchedMovies;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from Watched Movies'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watched Movies'),
      ),
      body: watchedMovies.isEmpty
          ? Center(child: Text('No movies watched yet'))
          : ListView.builder(
              itemCount: watchedMovies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(watchedMovies[index]['title']),
                  subtitle: Text('Rating: ${watchedMovies[index]['vote_average'].toStringAsFixed(1)}'),
                  leading: Image.network('https://image.tmdb.org/t/p/w200${watchedMovies[index]['poster_path']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeFromWatchedMovies(watchedMovies[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}
