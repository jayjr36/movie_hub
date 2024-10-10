import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_hub/extensions/apis.dart';
import 'package:movie_hub/models/genre.dart';
import 'package:movie_hub/models/movie.dart';

class MovieController {
  Future<List<String>> getMoviesFromAPI() async {
    final response = await http.get(
        Uri.parse('${ApiList.baseUrl}3/movie/11?api_key=${ApiList.apiKey}'));

    //https://www.themoviedb.org/authenticate/{REQUEST_TOKEN}?redirect_to=http://www.yourapp.com/approved

    if (response.statusCode == 200) {
      List<String> movies = List<String>.from(jsonDecode(response.body));
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(
        '${ApiList.baseUrl + ApiList.popularMovie}?api_key=${ApiList.apiKey}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Movie> results = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return results;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<String>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(
        '${ApiList.baseUrl + ApiList.trendingMovie}?api_key=${ApiList.apiKey}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<String> results = (data['results'] as List)
          .map((json) => Movie.fromJson(json).title)
          .toList();
      return results;
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(
        '${ApiList.baseUrl + ApiList.upcomingMovies}?api_key=${ApiList.apiKey}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Movie> results = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return results;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getPlayingMovies() async {
    final response = await http.get(Uri.parse(
        '${ApiList.baseUrl + ApiList.nowPlaying}?api_key=${ApiList.apiKey}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Movie> results = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return results;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(
        '${ApiList.baseUrl + ApiList.topRated}?api_key=${ApiList.apiKey}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Movie> results = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return results;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Genre>> getMovieGenre() async {
    final response =
        await http.get(Uri.parse('${ApiList.baseUrl + ApiList.movieGenre}?api_key=${ApiList.apiKey}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Genre> results =
          (data['genres'] as List).map((json) => Genre.fromJson(json)).toList();
      return results;
    } else {
      print(response.body);
      throw Exception('Failed to load movies genre');
    }
  }

  Future<List<Movie>> fetchMovies({Map<String, String>? filters}) async {
  final apiKey = ApiList.apiKey; 
  final baseUrl = ApiList.baseUrl+ApiList.filterMovies;

  final uri = Uri.parse(baseUrl).replace(queryParameters: {
    'api_key': apiKey,
    'language': 'en-US',
    'sort_by': 'popularity.desc',  
    ...?filters,  
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
     List<Movie> results = (jsonData['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
  
    return results; // List of movies
  } else {
    throw Exception('Failed to load movies');
  }
}
}
