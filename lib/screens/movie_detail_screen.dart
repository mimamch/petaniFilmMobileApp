import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:better_player/better_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/link.dart';
import 'package:flutter_application_1/models/movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wakelock/wakelock.dart';

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
  List<Link>? subtitleLinks = [];
  Future<void> getData() async {
    try {
      Response data = await Dio().get(
          '${Constants.petaniFilmBaseUrl}/movie/get-movie-by-tmdb-id/${widget.tmdbId}');
      Response links = await Dio().get(
          '${Constants.petaniFilmBaseUrl}/movie/get-movie-links?tmdbId=${widget.tmdbId}');
      Response subs = await Dio().get(
          '${Constants.petaniFilmBaseUrl}/movie/get-movie-subtitles?tmdbId=${widget.tmdbId}');

      Iterable it = links.data['data']['streamingLinks'];
      Iterable itSubtitles = subs.data['data']['subtitles'];
      List<Link> streamLink = it.map((e) => Link.fromJson(e)).toList();
      List<Link> subsLink = itSubtitles.map((e) => Link.fromJson(e)).toList();
      setState(() {
        streamingLinks = streamLink;
        subtitleLinks = subsLink;
        // betterPlayerDataSource = BetterPlayerDataSource(
        //     BetterPlayerDataSourceType.network,
        //     (streamingLinks != null && streamingLinks!.length > 0)
        //         ? streamingLinks![0].link
        //         : 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');

        // _betterPlayerController = BetterPlayerController(
        //     BetterPlayerConfiguration(
        //       aspectRatio: 16 / 9,
        //       errorBuilder: (context, errorMessage) => Text('$errorMessage'),
        //     ),
        //     betterPlayerDataSource: betterPlayerDataSource);
        details = MovieDetails.fromJson(data.data['data']);

        // videoLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      // Navigator.pop(context);
    }
  }

  bool videoLoading = false;
  BetterPlayerDataSource? betterPlayerDataSource;
  BetterPlayerController? _betterPlayerController;
  Link? nowMovieLinkPlayed;
  Link? nowSubtitlePlayed;
  @override
  void initState() {
    if (mounted) {
      initFunction();
      Wakelock.enable();
    }

    // _betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(
    //   showPlaceholderUntilPlay: true,
    //   placeholder: Text('Loading...'),
    //   errorBuilder: (context, errorMessage) => Text('Error'),
    // ));

    super.initState();
  }

  // @override
  // void dispose() {
  //   _betterPlayerController?.dispose();
  //   super.dispose();
  // }

  void initFunction() {
    getData();
    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        // aspectRatio: 16 / 9,
        autoDispose: false,
        autoDetectFullscreenAspectRatio: true,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 17, backgroundColor: Constants.kBlackColor),
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableQualities: false,
          controlsHideTime: Duration(milliseconds: 0),
          enableSkips: false,
          enableAudioTracks: false,
          enablePip: false,
        ),
      ),
    );
  }

  void changeStreamingServer(Link link) async {
    // print(link.link);

    betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, link.link,
        subtitles: subtitleLinks
            ?.map((e) => BetterPlayerSubtitlesSource(
                type: BetterPlayerSubtitlesSourceType.network,
                name: e.language,
                urls: [e.link]))
            .toList());

    nowMovieLinkPlayed = link;
    // _betterPlayerController!.addEventsListener((event) => {
    //       if (event == BetterPlayerEventType.exception)
    //         {
    //           setState(() {
    //             videoLoading = false;
    //             _betterPlayerController = null;
    //           }),
    //           debugPrint('ERROR EXCEPTION'),
    //           AwesomeDialog(
    //             context: context,
    //             animType: AnimType.scale,
    //             headerAnimationLoop: false,
    //             dialogType: DialogType.error,
    //             title: 'Upss...',
    //             desc: "Terjadi Kesalahan! \n Silahkan Gunakan Server Lain!",
    //             btnOkOnPress: () {},
    //             btnOkIcon: Icons.check_circle,
    //           ).show(),
    //         }
    //     });
    // _betterPlayerController!.setOverriddenFit(BoxFit.cover);
    setState(() {
      videoLoading = true;
    });
    await Future.delayed(Duration(seconds: 1), () {});
    _betterPlayerController!
        .setupDataSource(betterPlayerDataSource!)
        .then((response) {
      videoLoading = false;
      setState(() {});
    }).catchError((error) async {
      debugPrint('${error.toString()}');
      debugPrint('VIDEO ERROR');
      videoLoading = false;
      nowMovieLinkPlayed = null;
      setState(() {});
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        title: 'Upss...',
        desc: "Terjadi Kesalahan Pada Server! \n Gunakan Server Lain!",
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // _betterPlayerController!.pause();
        _betterPlayerController!.dispose(forceDispose: true);
        debugPrint('VIDEO DISPOSED');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constants.kWhiteColor.withOpacity(0.90),
          foregroundColor: Constants.kBlackColor,
        ),
        backgroundColor: Constants.kWhiteColor.withOpacity(0.95),
        body: (details == null)
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
                          ? Container(
                              color: Constants.kBlackColor,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Constants.kWhiteColor,
                              )),
                            )
                          : (nowMovieLinkPlayed == null ||
                                  _betterPlayerController == null)
                              ? Container(
                                  color: Constants.kBlackColor,
                                  child: Center(
                                    child: Text(
                                      'Choose Streaming Server',
                                      style: TextStyle(
                                          color: Constants.kWhiteColor,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                )
                              : BetterPlayer(
                                  controller: _betterPlayerController!)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Streaming Server :',
                        ),
                        Wrap(
                          spacing: 10,
                          children: streamingLinks!
                              .map((e) => ElevatedButton(
                                    onPressed: () {
                                      changeStreamingServer(e);
                                    },
                                    child: Text(
                                      '${e.provider}',
                                      style: TextStyle(
                                        color: Constants.kWhiteColor
                                            .withOpacity(0.9),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        elevation:
                                            const MaterialStatePropertyAll(0),
                                        padding: const MaterialStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                        ),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                (nowMovieLinkPlayed != null &&
                                                        nowMovieLinkPlayed!
                                                                .link ==
                                                            e.link)
                                                    ? Constants.kGreyColor
                                                    : Constants.kBlackColor)),
                                  ))
                              .toList(),
                        ),
                        Text(
                          widget.title + ' (${details?.releaseYear ?? '-'})',
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
      ),
    );
  }
}
