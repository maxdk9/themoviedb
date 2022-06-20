// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/services/auth_service.dart';

import '../domain/api_client/api_client_exception.dart';
import '../navigation/main_navigation.dart';

class MovieDetailPosterData {
  final String? backdropPath;
  final String? posterPath;
  final Icon favoriteIcon;
  MovieDetailPosterData({
    this.backdropPath,
    this.posterPath,
    required this.favoriteIcon,
  });
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
  MovieDetailPosterData posterData =
      MovieDetailPosterData(favoriteIcon: const Icon(Icons.favorite_outline));
  MovieDetailsMovieNameData nameData =
      MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsMovieScoreData scoreData =
      MovieDetailsMovieScoreData(voteAverage: 0);
  String summary = '';
  List<List<MovieDetailsMoviePeoplelData>> peopleData = [];
  List<MovieDetailsMovieActorData> actorsData = [];
}

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final authService = AuthService();

  final int moveId;
  final data = MovieDetailsData();
  String _locale = '';
  bool _isFavorite = false;
  MovieDetails? _movieDetails;
  late DateFormat _dateFormat = DateFormat.yMMMM();

  MovieDetailsModel({required this.moveId});

  MovieDetails? get movieDetails => _movieDetails;

  bool get isFavorite => _isFavorite;

  Future<void>? Function()? onSessionExpired;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) {
      return;
    } else {
      _dateFormat = DateFormat.yMMMM(locale);
      _locale = locale;
    }
    updateData(null, false);
    await loadDetails(context);
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    final newfavorite = !_isFavorite;
    if (sessionId != null && accountId != null) {
      _isFavorite = newfavorite;
      updateData(movieDetails, _isFavorite);

      try {
        await _accountApiClient.markAsFavorite(
            accountId: accountId,
            sessionId: sessionId,
            mediaType: MediaType.movie,
            mediaId: moveId,
            favorite: newfavorite);
      } on ApiClientException catch (e) {
        _handleApiClientException(e, context);
      }
    }
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      _movieDetails = await _apiClient.movieDetails(moveId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isFavorite(this.moveId, sessionId);
        updateData(movieDetails, _isFavorite);
      }
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
        favoriteIcon:
            Icon(isFavorite ? Icons.favorite : Icons.favorite_outline));

    var year = details.releaseDate?.year.toString();
    year = year != null ? ' $year' : '';
    data.nameData = MovieDetailsMovieNameData(name: details.title, year: year);

    var voteAverage = details.voteAverage;
    voteAverage = voteAverage * 10;
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos.first.key : null;

    data.scoreData = MovieDetailsMovieScoreData(
        voteAverage: voteAverage, trailerKey: trailerKey);

    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);

    final cast = details.credits.cast;
    if(cast!=null){
        data.actorsData =cast
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
