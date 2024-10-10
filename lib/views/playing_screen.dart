import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:movie_hub/controller/moviectrl.dart';
import 'package:movie_hub/extensions/constants.dart';
import 'package:movie_hub/models/movie.dart';
import 'package:movie_hub/views/movie_details.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  List<Movie> movies = [];
  List<Movie> topRatedMovies = [];
  bool isloading = false;

  void initState() {
    super.initState();
    getPlayingMovies();
    getRatedMovies();
  }

  Future<List<Movie>> getPlayingMovies() async {
    setState(() {
      isloading = true;
    });
    movies = await MovieController().getPlayingMovies();
    setState(() {
      isloading = false;
    });
    return movies;
  }

  Future<List<Movie>> getRatedMovies() async {
    setState(() {
      isloading = true;
    });
    topRatedMovies = await MovieController().getTopRatedMovies();
    setState(() {
      isloading = false;
    });
    return topRatedMovies;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Hub'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing in Theaters',
                style: AppConstant.smallText.copyWith(fontSize: 14),
              ),
              SizedBox(
                height: h * 0.29,
                child: LoadingOverlay(
                  isLoading: isloading,
                  progressIndicator: const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                      overview: movies[index].overview,
                                      title: movies[index].title,
                                      releaseDate: movies[index].releaseDate,
                                      image:
                                          'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                                      genre: movies[index].genre)));
                        },
                        child: Container(
                          height: h * 0.25,
                          margin: const EdgeInsets.all(10),
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                                  width: h * 0.15,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Ratings ${movies[index].voteAverage.toStringAsFixed(1)}',
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Text(
                'Top Rated Movies',
                style: AppConstant.smallText.copyWith(fontSize: 14),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              SizedBox(
                height: h * 0.5,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.2,
                    mainAxisExtent: h * 0.22,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topRatedMovies.length,
                  itemBuilder: (context, index) {
                    return LoadingOverlay(
                      isLoading: isloading,
                      progressIndicator: const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                      overview: topRatedMovies[index].overview,
                                      title: topRatedMovies[index].title,
                                      releaseDate:
                                          topRatedMovies[index].releaseDate,
                                      image:
                                          'https://image.tmdb.org/t/p/w500${topRatedMovies[index].posterPath}',
                                      genre: topRatedMovies[index].genre)));
                        },
                        child: Container(
                          height: h * 0.25,
                          margin: const EdgeInsets.all(3),
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${topRatedMovies[index].posterPath}',
                                  width: h * 0.12,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Ratings ${topRatedMovies[index].voteAverage.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(int index, String title, String description, String image) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        double h = MediaQuery.of(context).size.height;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 15,
          backgroundColor: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${image}',
                  width: double.infinity,
                  height: h * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
