import 'package:flutter/cupertino.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/domain/entity_local/MovieDetailsLocal.dart';

import '../api_client/api_client_exception.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    return await _movieApiClient.popularMovie(
        page, locale, Configuration.apiKey);
  }

  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query) async {
    return await _movieApiClient.searchMovie(
        page, locale, query, Configuration.apiKey);
  }

  Future<MovieDetailsLocal> loadDetails(
      {required int movieId, required String locale}) async {
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    var isFavorite = false;
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }
    MovieDetailsLocal movieDetailsLocal =
        MovieDetailsLocal(movieDetails: movieDetails, isFavorite: isFavorite);
    return movieDetailsLocal;
  }

  Future<void> updateFavorite({required int moveId,required bool isFavorite}) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    

    if (sessionId != null && accountId != null) {

      await _accountApiClient.markAsFavorite(
            accountId: accountId,
            sessionId: sessionId,
            mediaType: MediaType.movie,
            mediaId: moveId,
            favorite: isFavorite);
      
      
    }
  }
}
