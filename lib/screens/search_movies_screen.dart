import 'package:flutter/material.dart';
import 'package:moviemania/services/movie_service.dart';
import 'package:moviemania/services/storage_service.dart';

class MovieSearchDelegate extends SearchDelegate {
  final MovieService movieService;
  final StorageService storageService;
  final Future<bool> Function(dynamic) isInWatchList;
  final Future<bool> Function(dynamic) isInWatchedMovies;
  final Function(dynamic) addToWatchList;
  final bool isGridView;

  MovieSearchDelegate(
    this.movieService,
    this.storageService,
    this.isInWatchList,
    this.isInWatchedMovies,
    this.addToWatchList, {
    required this.isGridView,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: movieService.searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> results = snapshot.data ?? [];
          return isGridView
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return _buildResultItemGrid(results[index]);
                  },
                )
              : ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return _buildResultItemList(results[index]);
                  },
                );
        }
      },
    );
  }

  Widget _buildResultItemGrid(dynamic movie) {
    return FutureBuilder<List<bool>>(
      future: Future.wait([
        isInWatchList(movie),
        isInWatchedMovies(movie),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          bool inWatchList = snapshot.data![0];
          bool inWatchedMovies = snapshot.data![1];

          return GridTile(
            child: Image.network(
                'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                fit: BoxFit.cover),
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Text(
                movie['title'],
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text('Rating: ${movie['vote_average'].toStringAsFixed(1)}'),
              trailing: IconButton(
                icon: inWatchedMovies
                    ? Icon(Icons.check, color: Colors.green)
                    : (inWatchList
                        ? Icon(Icons.bookmark, color: Colors.white)
                        : Icon(Icons.bookmark_border)),
                onPressed: inWatchedMovies || inWatchList
                    ? null
                    : () {
                        addToWatchList(movie);
                      },
              ),
            ),
          );
        } else {
          return Center(child: Text('Error: No data'));
        }
      },
    );
  }

  Widget _buildResultItemList(dynamic movie) {
    return FutureBuilder<List<bool>>(
      future: Future.wait([
        isInWatchList(movie),
        isInWatchedMovies(movie),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          bool inWatchList = snapshot.data![0];
          bool inWatchedMovies = snapshot.data![1];

          return ListTile(
            title: Text(movie['title']),
            subtitle: Text(
                'Rating: ${movie['vote_average'].toStringAsFixed(1)}'),
            leading: Image.network(
                'https://image.tmdb.org/t/p/w200${movie['poster_path']}'),
            trailing: IconButton(
              icon: inWatchedMovies
                  ? Icon(Icons.check, color: Colors.green)
                  : (inWatchList
                      ? Icon(Icons.bookmark, color: Colors.black)
                      : Icon(Icons.bookmark_border)),
              onPressed: inWatchedMovies || inWatchList
                  ? null
                  : () {
                      addToWatchList(movie);
                    },
            ),
          );
        } else {
          return Center(child: Text('Error: No data'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
