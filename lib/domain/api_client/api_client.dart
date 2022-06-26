import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:themoviedb/domain/api_client/network_client.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import '../entity/movie_details.dart';

class MovieApiClient {
  final _networkClient = NetworkClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale,String apiKey) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = await _networkClient.get<PopularMovieResponse>(
        '/movie/popular/', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale
    });
    return result;
  }

  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query,String apiKey) {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }


    final result = _networkClient
        .get<PopularMovieResponse>('/search/movie/', parser, <String, dynamic>{
      'api_key': apiKey,
      'page': page.toString(),
      'language': locale,
      'include_adult': true.toString(),
      'query': query,
    });

    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) {
    parser (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient
        .get<MovieDetails>('/movie/$movieId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': Configuration.apiKey,
      'language': locale,
    });
    return result;
  }

  Future<bool> isFavorite(int movieId, String sessionId) {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final bool result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = _networkClient.get<bool>(
        '/movie/$movieId/account_states', parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionId
    });
    return result;
  }

  Future<String> readResponse(HttpClientResponse response) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}

Future<String> readResponse(HttpClientResponse response) {
  final completer = Completer<String>();
  final contents = StringBuffer();
  response.transform(utf8.decoder).listen((data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}
