import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/movie.dart';
import 'package:flutter_application_1/screens/movie_detail_screen.dart';

class HomeMovieItem extends StatelessWidget {
  final Movie movie;
  final double itemWidth;
  final double itemHeight;
  const HomeMovieItem(
      {super.key,
      required this.movie,
      required this.itemHeight,
      required this.itemWidth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          headerAnimationLoop: false,
          dialogType: DialogType.info,
          title: movie.title,
          desc: movie.overview,
          btnOkOnPress: () {},
          btnOkIcon: Icons.check_circle,
        ).show();
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => MovieDetailScreen(
                  title: movie.title,
                  imageUrl: movie.posterPath,
                  overview: movie.overview,
                  rating: movie.voteAverage,
                  tmdbId: movie.tmdbId,
                )),
          ),
        );
      },
      child: Center(
        child: Container(
          // margin: EdgeInsets.only(left: 20),
          // color: Constants.kGreyColor,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: itemWidth,
                  height: itemHeight,
                  color: Constants.kGreyColor,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w200/${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  // width: double.infinity,
                  // height: 40,

                  padding: EdgeInsets.symmetric(vertical: 5),
                  // color: Constants.kBlackColor.withOpacity(0.8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                        stops: const [
                          0.0,
                          0.3,
                        ],
                        colors: [
                          Constants.kBlackColor.withOpacity(0.0),
                          Constants.kBlackColor.withOpacity(0.6)
                        ]),
                    // color: Constants.kBlackColor.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  child: SizedBox(
                    width: itemWidth,
                    child: RichText(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 12.0),
                      maxLines: 2,
                      text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Constants.kWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                          text:
                              (movie.title ?? '-') + ' (${movie.releaseYear})'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
