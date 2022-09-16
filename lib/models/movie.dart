import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/genre.dart';
import 'package:flutter_application_1/models/productCompanies.dart';

class Movie {
  bool? adult;
  String? backdropPath;
  int? id;
  int? tmdbId;
  String? imdbId;
  String? title;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? mediaType;
  List<int>? genreIds;
  double? popularity;
  String? releaseDate;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? releaseYear;

  Movie(
      {this.adult,
      this.backdropPath,
      this.id,
      this.tmdbId,
      this.imdbId,
      this.title,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.posterPath,
      this.mediaType,
      this.genreIds,
      this.popularity,
      this.releaseDate,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.releaseYear});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        adult: json['adult'],
        backdropPath: json['tmdbBackdropPath'] ?? json['backdrop_path'],
        id: json['id'],
        tmdbId: (json['tmdbId'] ?? 0),
        imdbId: json['imdbId'],
        title: json['title'],
        originalLanguage: json['originalLanguage'] ?? json['original_language'],
        originalTitle: json['originalTitle'] ?? json['original_title'],
        overview: json['overview'],
        posterPath: json['tmdbPosterPath'] ?? json['poster_path'],
        genreIds: (json['tmdbGenresId'] ?? json['genre_ids']).cast<int>(),
        popularity: json['popularity'],
        releaseDate: json['releaseDate'] ?? json['release_date'],
        video: json['video'],
        voteAverage:
            (json['voteAverage'] ?? json['vote_average'] ?? 0.0).toDouble(),
        voteCount: json['voteCount'] ?? json['voteCount'],
        releaseYear: (json['releaseDate'] ?? json['release_date'])
            .toString()
            .split('-')[0]);
  }

  static Future<List> getTrendingMovies() async {
    try {
      var data = await Dio().get(Constants.tmdbApiUrl +
          Constants.tmdbAllTrendingUrl +
          Constants.tmdbApiQueryKey);
      List response = data.data['results'];
      return response;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

class MovieDetails {
  bool? adult;
  String? backdropPath;
  int? budget;
  List<Genre>? genres;
  String? homepage;
  int? id;
  String? imdbId;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  int? revenue;
  int? runtime;
  String? status;
  String? tagline;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? genreFinal;
  String? releaseYear;

  MovieDetails(
      {this.adult,
      this.backdropPath,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.genreFinal,
      this.releaseYear});

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    Iterable gen = json['genres'];
    // String genreFinal = gen.map((c) => c['name']).toList().join(', ');
    String genreFinal = gen.map((c) => c).toList().join(', ');
    // List<Genre> genres = gen.map((e) => Genre.fromJson(e)).toList();
    List<Genre> genres = gen.map((e) => Genre(name: e)).toList();
    return MovieDetails(
        adult: json['adult'],
        backdropPath: json['tmdbBackdropPath'] ?? json['backdrop_path'],
        budget: json['budget'],
        genres: genres,
        homepage: json['homepage'],
        id: json['id'],
        imdbId: json['imdb_id'],
        originalLanguage: json['originalLanguage'] ?? json['original_language'],
        originalTitle: json['originalTitle'] ?? json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterPath: json['poster_path'] ?? json['posterPath'],
        releaseDate: json['release_date'] ?? json['releaseDate'],
        revenue: json['revenue'],
        runtime: json['runtime'],
        status: json['status'],
        tagline: json['tagline'],
        title: json['title'],
        video: json['video'],
        voteAverage: json['vote_average'] ?? json['voteAverage'],
        voteCount: json['vote_count'] ?? json['voteCount'],
        genreFinal: genreFinal,
        releaseYear: (json['releaseDate'] ?? json['release_date'])
            .toString()
            .split('-')[0]);
  }
}
