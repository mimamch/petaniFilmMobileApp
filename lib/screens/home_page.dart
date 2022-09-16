// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/home_movie_item.dart';
import 'package:flutter_application_1/components/masked_image.dart';
import 'package:flutter_application_1/components/search_field_widget.dart';
import 'package:flutter_application_1/constants.dart';
// import 'package:flutter_application_1/models/movie.dart';
import 'package:flutter_application_1/models/movie.dart';
import 'package:flutter_application_1/screens/movie_detail_screen.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _fetchPage(int pageKey) async {
    try {
      Response response = await Dio().get(
          '${Constants.petaniFilmBaseUrl}${Constants.petaniFilmGetMovieUrl}?page=$pageKey');
      // if (response.statusCode == 200) {
      Iterable it = response.data['data']['results'];
      // List<Movie> data = it.map((e) => Movie.fromJson(e)).toList();
      // setState(() {
      //   trendingMovies = data;
      // });
      List<Movie> movieList = it.map((e) => Movie.fromJson(e)).toList();
      final isLastPage =
          response.data['data']['page'] == response.data['data']['total_pages'];
      if (isLastPage) {
        _pagingController.appendLastPage(movieList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(movieList, nextPageKey);
      }
      // }
    } catch (e) {
      print("error --> $e");
      _pagingController.error = e;
    }
  }

  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);

  List<Movie>? trendingMovies = [];
  int page = 1;

  @override
  void initState() {
    // getData(1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 50) / 3;
    double itemHeight = itemWidth * 1.5;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Petani Film',
          style: TextStyle(
            color: Constants.kBlackColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Constants.kWhiteColor.withOpacity(0.9),
        elevation: 0,
      ),
      body: trendingMovies == null
          ? Center(
              child: CircularProgressIndicator(color: Constants.kBlackColor),
            )
          : Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Expanded(
                    child: Center(
                      child: PagedGridView<int, Movie>(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: itemWidth / itemHeight,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        pagingController: _pagingController,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        showNewPageProgressIndicatorAsGridChild: false,
                        showNewPageErrorIndicatorAsGridChild: false,
                        showNoMoreItemsIndicatorAsGridChild: false,
                        builderDelegate: PagedChildBuilderDelegate(
                            animateTransitions: true,
                            firstPageProgressIndicatorBuilder: (context) =>
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Constants.kBlackColor,
                                  ),
                                ),
                            itemBuilder: ((context, item, index) {
                              return HomeMovieItem(
                                movie: item,
                                itemHeight: itemHeight,
                                itemWidth: itemWidth,
                              );
                            })),
                      ),
                    ),
                  ),
                ]),
    );
  }
}
