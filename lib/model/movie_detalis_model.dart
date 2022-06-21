// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/domain/services/movie_service.dart';
import 'package:themoviedb/library/localized_model.dart';

import '../domain/api_client/api_client_exception.dart';
import '../domain/entity_local/MovieDetailsLocal.dart';
import '../navigation/main_navigation.dart';

class MovieDetailPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;
  Icon get favoriteIcon =>
      Icon(isFavorite ? Icons.favorite : Icons.favorite_outline);

  MovieDetailPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String name;
  final String year;
  MovieDetailsMovieNameData({
    required this.name,
    required this.year,
  });
}

class MovieDetailsMovieScoreData {
  final double voteAverage;
  final String? trailerKey;
  MovieDetailsMovieScoreData({
    required this.voteAverage,
    this.trailerKey,
  });
}

class MovieDetailsMoviePeoplelData {
  final String name;
  final String job;
  MovieDetailsMoviePeoplelData({
    required this.name,
    required this.job,
  });
}

class MovieDetailsMovieActorData {
  String name;
  String character;
  String? profilePath;
  MovieDetailsMovieActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsData {
  String title = 'Loading';
  bool isLoading = true;
  String overview = '';
  MovieDetailPosterData posterData = MovieDetailPosterData();
  MovieDetailsMovieNameData nameData =
      MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsMovieScoreData scoreData =
      MovieDetailsMovieScoreData(voteAverage: 0);
  String summary = '';
  List<List<MovieDetailsMoviePeoplelData>> peopleData = [];
  List<MovieDetailsMovieActorData> actorsData = [];
}

class MovieDetailsModel extends ChangeNotifier {
  final _accountApiClient = AccountApiClient();

  final authService = AuthService();
  final _movieService = MovieService();

  final int moveId;
  final data = MovieDetailsData();
  

  late DateFormat _dateFormat = DateFormat.yMMMM();

  MovieDetailsModel({required this.moveId});

  Future<void>? Function()? onSessionExpired;
  final LocalizedModelStorage _localeStorage = LocalizedModelStorage();

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMM(_localeStorage.localeTag);
  
    updateData(null, false);
    await loadDetails(context);
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();

    try {
      _movieService.updateFavorite(
          moveId: moveId, isFavorite: data.posterData.isFavorite);
      /* await _accountApiClient.markAsFavorite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: MediaType.movie,
          mediaId: moveId,
          favorite: newfavorite); */
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final MovieDetailsLocal movieDetailsLocal =
          await _movieService.loadDetails(movieId: moveId, locale: _localeStorage.localeTag);

      updateData(movieDetailsLocal.movieDetails, movieDetailsLocal.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? 'Loading';
    data.isLoading = (details == null);
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.posterData = MovieDetailPosterData(
        backdropPath: details.backdropPath,
        posterPath: details.posterPath,
        isFavorite: isFavorite);

    var year = details.releaseDate?.year.toString();
    year = year != null ? ' $year' : '';
    data.nameData = MovieDetailsMovieNameData(name: details.title, year: year);

    var voteAverage = details.voteAverage;
    voteAverage = voteAverage * 10;
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;

    data.scoreData = MovieDetailsMovieScoreData(
        voteAverage: voteAverage, trailerKey: trailerKey);

    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);

    final cast = details.credits.cast;
    if (cast != null) {
      data.actorsData = cast
          .map((act) => MovieDetailsMovieActorData(
              name: act.name,
              character: act.character,
              profilePath: act.profilePath))
          .toList();
    }

    notifyListeners();
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];
    var releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(stringFromDate(releaseDate));
    }
    final productCountries = details.productionCountries;
    if (productCountries.isNotEmpty) {
      texts.add('(${productCountries.first.iso})');
    }
    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres = details.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      final genresString = genresNames.join(', ');
      texts.add(genresString);
    }
    return texts.join(' ');
  }

  List<List<MovieDetailsMoviePeoplelData>> makePeopleData(
      MovieDetails details) {
    var crew = details.credits.crew
        ?.map((e) => MovieDetailsMoviePeoplelData(name: e.name, job: e.job))
        .toList();
    if (crew == null) {
      return [];
    }
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<MovieDetailsMoviePeoplelData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return crewChunks;
  }

  void _handleApiClientException(ApiClientException e, BuildContext context) {
    switch (e.type) {
      case ApiClientExceptionType.sessionExpired:
        authService.logout();
        MainNavigation.resetNavigation(context);
        // onSessionExpired?.call();
        break;
      default:
        print(e);
    }
  }

  String stringFromDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return _dateFormat.format(date);
  }
}
