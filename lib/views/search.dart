import 'package:flutter/material.dart';
import 'package:movie_hub/controller/moviectrl.dart';
import 'package:movie_hub/extensions/constants.dart';
import 'package:movie_hub/models/movie.dart';
import 'package:movie_hub/views/movie_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  // Store filters and search results
  Map<String, String> filters = {};
  List<Movie> movies = [];
  List<Movie> filteredMovies = []; // To store the filtered movie list
  bool isLoading = false;
  bool showNameField = false; // Toggle for movie name field
  String? movieName; // Store the movie name search query

  // Dropdown options for filters as key-value pairs
  String? selectedFilterType;
  final Map<String, String> filterOptions = {
    '28': 'Action',
    '12': 'Adventure',
    '16': 'Animation',
    '35': 'Comedy',
    '80': 'Crime',
    '99': 'Documentary',
    '18': 'Drama',
    '10751': 'Family',
  };

  // Search movies based on genre
  void _searchMovies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await MovieController().fetchMovies(filters: filters);
      print("filters: $filters");

      // Sort results by release date
      results.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));

      setState(() {
        movies = results;
        filteredMovies = results; // Initially, filteredMovies holds all movies
      });
      filters.clear();
    } catch (error) {
      print('Error fetching movies: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Filter movies by name from the genre-filtered list
  void _filterMoviesByName(String name) {
    setState(() {
      filteredMovies = movies
          .where((movie) => movie.title.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Search',
            style: AppConstant.largeText.copyWith(color: AppConstant.primaryColor),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(showNameField ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                showNameField = !showNameField;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Genre dropdown
                DropdownButtonFormField<String>(
                  value: selectedFilterType,
                  items: filterOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppConstant.primaryColor),
                    ),
                    labelText: 'Genre',
                    labelStyle: TextStyle(color: AppConstant.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppConstant.primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filters['with_genres'] = value!;
                    });
                    _searchMovies();
                  },
                ),

                const SizedBox(height: 16),

                // Movie name search field (initially hidden)
                if (showNameField)
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppConstant.primaryColor),
                      ),
                      labelText: 'Movie Name',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (movieName != null && movieName!.isNotEmpty) {
                            _filterMoviesByName(movieName!);
                          }
                        },
                        child: const Icon(Icons.search),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppConstant.primaryColor),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        movieName = value;
                      });
                    },
                  ),
              ],
            ),
          ),
          
          // Movie list
          Expanded(
            child: filteredMovies.isEmpty && isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredMovies.isEmpty && !isLoading
                    ? const Center(child: Text('No movies found'))
                    : ListView.builder(
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = filteredMovies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                    overview: movie.overview,
                                    title: movie.title,
                                    releaseDate: movie.releaseDate,
                                    image: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    genre: movie.genre,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  ),
                                ),
                                title: Text(
                                  movie.title,
                                  style: AppConstant.mediumText.copyWith(fontSize: 14),
                                ),
                                subtitle: Text(
                                  'Release Date: ${movie.releaseDate}',
                                  style: AppConstant.smallText,
                                ),
                                trailing: Text(
                                  'Details',
                                  style: AppConstant.smallText.copyWith(
                                    color: AppConstant.primaryColor,
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
    );
  }
}
