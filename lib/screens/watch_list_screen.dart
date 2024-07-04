import 'package:flutter/material.dart';
import 'package:moviemania/services/storage_service.dart';

class WatchListScreen extends StatefulWidget {
  @override
  _WatchListScreenState createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final StorageService storageService = StorageService();
  List<dynamic> watchList = [];

  @override
  void initState() {
    super.initState();
    _fetchWatchList();
  }

  void _fetchWatchList() async {
    List<dynamic> fetchedWatchList = await storageService.getWatchList();
    setState(() {
      watchList = fetchedWatchList;
    });
  }

  void removeFromWatchList(dynamic movie) async {
    List<dynamic> updatedWatchList =
        watchList.where((item) => item['id'] != movie['id']).toList();
    await storageService.saveWatchList(updatedWatchList);
    setState(() {
      watchList = updatedWatchList;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from Watch List'),
      ),
    );
  }

  void addToWatchedMovies(dynamic movie) async {
    List<dynamic> watchedMovies = await storageService.getWatchedMovies();
    watchedMovies.add(movie);
    await storageService.saveWatchedMovies(watchedMovies);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Watched Movies'),
      ),
    );
    // Remove from watch list after adding to watched movies
    removeFromWatchList(movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch List'),
      ),
      body: watchList.isEmpty
          ? Center(child: Text('Watch List is empty'))
          : ListView.builder(
              itemCount: watchList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(watchList[index]['title']),
                  subtitle: Text(
                      'Rating: ${watchList[index]['vote_average'].toStringAsFixed(1)}'),
                  leading: Image.network(
                      'https://image.tmdb.org/t/p/w200${watchList[index]['poster_path']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeFromWatchList(watchList[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          addToWatchedMovies(watchList[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
