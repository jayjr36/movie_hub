import 'package:flutter/material.dart';
import 'package:movie_hub/controller/moviectrl.dart';
import 'package:movie_hub/extensions/constants.dart';
import 'package:movie_hub/models/genre.dart';

class MovieDetails extends StatefulWidget {
  final String? overview, title, releaseDate, image;
  final List? genre;

  const MovieDetails(
      {super.key,
      required this.overview,
      required this.title,
      required this.releaseDate,
      required this.image,
      required this.genre});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.1),
        child: Column(
          children: [
            Center(
                child: Text(
              widget.title ?? 'Name',
              style: AppConstant.largeText .copyWith(color: AppConstant.primaryColor),
            )),
            const SizedBox(height: 10),
            Center(
              child: Image.network(
                  height: h * 0.25,
                  width: h * 0.4,
                  widget.image ??
                      "https://w7.pngwing.com/pngs/314/584/png-transparent-computer-icons-video-display-resolution-others-angle-text-rectangle-thumbnail.png"
                  //  "https://assets-in.bmscdn.com/discovery-catalog/events/tr:w-400,h-600,bg-CCCCCC/et00310216-tluebxpafx-portrait.jpg"
                  ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Synopsis",
                  style: AppConstant.smallText
                      .copyWith(color: AppConstant.primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  widget.overview ?? "Not found",
                  style: AppConstant.smallText.copyWith(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Release Date: ",
                      style: AppConstant.smallText
                          .copyWith(color: AppConstant.primaryColor),
                    ),
                    Text(
                      widget.releaseDate ?? "Null",
                      style: AppConstant.smallText,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      Text(
                        "Genre: ",
                        style: AppConstant.smallText
                            .copyWith(color: AppConstant.primaryColor),
                      ),
                      FutureBuilder<List<Genre>>(
                        future: MovieController().getMovieGenre(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return  Text(
                              "Loading...",
                              style: AppConstant.smallText,
                            );
                          } else if (snapshot.hasData) {
                            List<Genre> genres = snapshot.data!;
                            List<String> names = genres
                                .where((element) =>
                                    widget.genre!.contains(element.id))
                                .map((e) => e.name!)
                                .toList();
                            return Text(
                              names.join(", "),
                              style: AppConstant.smallText,
                            );
                          } else {
                            return  Text(
                              "Error",
                              style: AppConstant.smallText,
                            );
                          }
                        },
                      ),
                    ],
                  )),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                    // side: const BorderSide(width: 2, color: Colors.white),
                    backgroundColor: AppConstant.primaryColor),
                child: Text(
                  'Watch Later',
                  style: AppConstant.largeText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
