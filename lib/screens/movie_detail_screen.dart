import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/masked_image.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/link.dart';
import 'package:flutter_application_1/models/movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

class MovieDetailScreen extends StatefulWidget {
  final imageUrl;
  final title;
  final overview;
  final tmdbId;
  final rating;
  const MovieDetailScreen(
      {Key? key,
      this.imageUrl = '',
      this.overview = '',
      this.title = '',
      this.rating = 0,
      required this.tmdbId})
      : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  String releaseDate = '-';
  String duration = '-';
  MovieDetails? details;
  List<Link>? streamingLinks;
  List<Link>? downloadLinks;
  Future<void> getData() async {
    try {
      Response data = await Dio().get(
          '${Constants.petaniFilmBaseUrl}/movie/get-movie-by-tmdb-id/${widget.tmdbId}');
      Response links = await Dio().get(
          '${Constants.petaniFilmBaseUrl}/movie/get-movie-links?tmdbId=${widget.tmdbId}');

      Iterable it = links.data['data']['streamingLinks'];
      List<Link> streamLink = it.map((e) => Link.fromJson(e)).toList();
      setState(() {
        streamingLinks = streamLink;
        betterPlayerDataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            (streamingLinks != null && streamingLinks!.length > 0)
                ? streamingLinks![0].link
                : 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');

        _betterPlayerController = BetterPlayerController(
            BetterPlayerConfiguration(
              aspectRatio: 16 / 9,
              errorBuilder: (context, errorMessage) => Text('$errorMessage'),
            ),
            betterPlayerDataSource: betterPlayerDataSource);
        details = MovieDetails.fromJson(data.data['data']);
        videoLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      // Navigator.pop(context);
    }
  }

  bool videoLoading = true;
  late BetterPlayerDataSource betterPlayerDataSource;

  late BetterPlayerController _betterPlayerController;
  @override
  void initState() {
    if (mounted) {
      initFunction();
    }

    super.initState();
  }

  void initFunction() async {
    getData();
    print(streamingLinks?[0].link);
    betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        streamingLinks != null
            ? streamingLinks![0].link
            : "https://media.developer.dolby.com/Atmos/MP4/Universe_Fury2.mp4");

    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          errorBuilder: (context, errorMessage) => Text('$errorMessage'),
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event == BetterPlayerEventType.exception) {
        debugPrint('got ERRROR');
      }
    });
    _betterPlayerController
        .setupDataSource(betterPlayerDataSource)
        .then((response) {
      setState(() {
        videoLoading = false;
      });
    }).catchError((error) async {
      debugPrint('VIDEO ERROR');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constants.kWhiteColor.withOpacity(0.90),
        foregroundColor: Constants.kBlackColor,
      ),
      backgroundColor: Constants.kWhiteColor.withOpacity(0.95),
      body: (details == null || videoLoading == true)
          ? Center(
              child: CircularProgressIndicator(
                color: Constants.kBlackColor,
              ),
            )
          : ListView(
              children: [
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: videoLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Constants.kBlackColor,
                            ),
                          )
                        : BetterPlayer(controller: _betterPlayerController)),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.7,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.title +
                                  ' (${details?.releaseYear ?? '-'})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Constants.kBlackColor.withOpacity(
                                  0.85,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight <= 667 ? 10 : 20,
                            ),
                            Text(
                              '${details?.releaseDate ?? '-'} | ${details?.runtime ?? 0} minutes | ${details?.genreFinal}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Constants.kBlackColor.withOpacity(
                                  0.75,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RatingBar.builder(
                              itemSize: 14,
                              initialRating: widget.rating / 2,
                              minRating: 1,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              allowHalfRating: true,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Constants.kYellowColor,
                              ),
                              onRatingUpdate: (rating) {
                                debugPrint(rating.toString());
                              },
                              unratedColor: Constants.kBlackColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.overview,
                              textAlign: TextAlign.center,
                              maxLines: screenHeight <= 667 ? 2 : 4,
                              style: TextStyle(
                                fontSize: 14,
                                color: Constants.kBlackColor.withOpacity(
                                  0.75,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Container(
                        height: 2,
                        width: screenWidth * 0.8,
                        color: Constants.kBlackColor.withOpacity(0.15),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
