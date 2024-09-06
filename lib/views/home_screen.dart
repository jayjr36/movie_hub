import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:movie_hub/controller/moviectrl.dart';
import 'package:movie_hub/extensions/constants.dart';
import 'package:movie_hub/models/movie.dart';
import 'package:movie_hub/widgets/button_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getPopularMovies();
  }

  Future<List<Movie>> getPopularMovies() async {
    setState(() {
      isloading = true;
    });
    movies = await MovieController().getUpcomingMovies();
    setState(() {
      isloading = false;
    });
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  'Hello',
                  style: AppConstant.largeText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: h * 0.01,
                ),
                Text('Daizy!',
                    style: AppConstant.largeText
                        .copyWith(fontWeight: FontWeight.bold))
              ],
            ),
            Text(
              'Check for latest movies',
              style: AppConstant.smallText,
            ),
            SizedBox(
              height: h * 0.03,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: h * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: h * 0.02),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      size: h * 0.03,
                    ),
                    suffixIcon: Icon(
                      Icons.mic,
                      size: h * 0.03,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Search Movies',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Filters',
                  style: AppConstant.mediumText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonIcon(
                      icon: Icons.movie_filter_rounded,
                      text: 'Genre',
                      onTap: () {}),
                  ButtonIcon(icon: Icons.star, text: 'Top IMDB', onTap: () {}),
                  ButtonIcon(
                      icon: Icons.language_rounded,
                      text: 'Language',
                      onTap: () {}),
                  ButtonIcon(
                      icon: Icons.local_movies_rounded,
                      text: 'Genre',
                      onTap: () {})
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Text(
                'Featured Movies',
                style:
                    AppConstant.largeText.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              CarouselSlider(
                items: List.generate(
                  movies.length,
                  (index) => Container(
                    height: h * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${movies[index].posterPath}'),
                            fit: BoxFit.cover)),
                  ),
                ),
                options: CarouselOptions(
                  aspectRatio: 1.2,
                  viewportFraction: 0.5,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
