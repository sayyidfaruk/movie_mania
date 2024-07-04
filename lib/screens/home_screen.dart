import 'package:flutter/material.dart';
import 'package:moviemania/screens/search_movies_screen.dart';
import 'package:moviemania/services/movie_service.dart';
import 'package:moviemania/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();
  final StorageService storageService = StorageService();
  List<dynamic> movies = [];
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() async {
    List<dynamic> fetchedMovies = await movieService.fetchPopularMovies();
    setState(() {
      movies = fetchedMovies;
    });
  }

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  Future<bool> isInWatchList(dynamic movie) async {
    List<dynamic> watchList = await storageService.getWatchList();
    return watchList.any((item) => item['id'] == movie['id']);
  }

  Future<bool> isInWatchedMovies(dynamic movie) async {
    List<dynamic> watchedMovies = await storageService.getWatchedMovies();
    return watchedMovies.any((item) => item['id'] == movie['id']);
  }

  void addToWatchList(dynamic movie) async {
    List<dynamic> watchList = await storageService.getWatchList();
    watchList.add(movie);
    await storageService.saveWatchList(watchList);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Watch List'),
      ),
    );
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        actions: [
          IconButton(
            icon: isGridView ? Icon(Icons.view_list) : Icon(Icons.grid_on),
            onPressed: toggleView,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  movieService,
                  storageService,
                  isInWatchList,
                  isInWatchedMovies,
                  addToWatchList,
                  isGridView: isGridView
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Image.asset('assets/icon.png'),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Watch List'),
              onTap: () {
                Navigator.pushNamed(context, '/watchlist');
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Watched Movies'),
              onTap: () {
                Navigator.pushNamed(context, '/watched');
              },
            ),
          ],
        ),
      ),
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : isGridView
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<List<bool>>(
                      future: Future.wait([
                        isInWatchList(movies[index]),
                        isInWatchedMovies(movies[index])
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
                                'https://image.tmdb.org/t/p/w200${movies[index]['poster_path']}',
                                fit: BoxFit.cover),
                            footer: GridTileBar(
                              backgroundColor: Colors.black45,
                              title: Text(movies[index]['title'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),),
                              subtitle: Text(
                                  'Rating: ${movies[index]['vote_average'].toStringAsFixed(1)}'),
                              trailing: IconButton(
                                icon: inWatchedMovies
                                    ? Icon(Icons.check, color: Colors.green)
                                    : (inWatchList
                                        ? Icon(Icons.bookmark, color: Colors.white)
                                        : Icon(Icons.bookmark_border)),
                                onPressed: inWatchedMovies || inWatchList
                                    ? null
                                    : () {
                                        addToWatchList(movies[index]);
                                      },
                              ),
                            ),
                          );
                        } else {
                          return Center(child: Text('Error: No data'));
                        }
                      },
                    );
                  },
                )
              : ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<List<bool>>(
                      future: Future.wait([
                        isInWatchList(movies[index]),
                        isInWatchedMovies(movies[index])
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
                            title: Text(movies[index]['title']),
                            subtitle: Text(
                                'Rating: ${movies[index]['vote_average'].toStringAsFixed(1)}'),
                            leading: Image.network(
                                'https://image.tmdb.org/t/p/w200${movies[index]['poster_path']}'),
                            trailing: IconButton(
                              icon: inWatchedMovies
                                  ? Icon(Icons.check, color: Colors.green)
                                  : (inWatchList
                                      ? Icon(Icons.bookmark, color: Colors.black)
                                      : Icon(Icons.bookmark_border)),
                              onPressed: inWatchedMovies || inWatchList
                                  ? null
                                  : () {
                                      addToWatchList(movies[index]);
                                    },
                            ),
                          );
                        } else {
                          return Center(child: Text('Error: No data'));
                        }
                      },
                    );
                  },
                ),
    );
  }
}