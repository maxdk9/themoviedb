import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:themoviedb/domain/entity/movie_details.dart';

import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import '../entity/movie_details.dart';


enum MediaType {
  Movie,
  Tv,
}

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.Movie:
        return 'movie';
      case MediaType.Tv:
        return 'tv';
    }
  }
}

enum ApiClientExceptionType { network, auth, sessionExpired, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const String _host = 'https://api.themoviedb.org/3';
  static const String _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '403fd00cd03d587671bd3aa39429a01d';

  static String imageUrl(String path) {
    return _imageUrl + path;
  }

  Uri makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    }
    return uri;
  }

  Future<dynamic> popularMovie(int page, String locale) {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    };

    final result = _get<dynamic>('/movie/popular/', parser, <String, dynamic>{
      'api_key': _apiKey,
      'page': page.toString(),
      'language': locale
    });
    return result;
  }

  Future<dynamic> searchMovie(int page, String locale, String query) {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    };

    final result = _get<dynamic>('/search/movie/', parser, <String, dynamic>{
      'api_key': _apiKey,
      'page': page.toString(),
      'language': locale,
      'include_adult': true.toString(),
      'query': query,
    });
    print('searchMovie $query');

    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    };

    final result =
        _get<MovieDetails>('/movie/$movieId', parser, <String, dynamic>{
      'append_to_response': 'credits,videos',
      'api_key': _apiKey,
      'language': locale,
    });
    return result;
  }

  Future<bool> isFavorite(int movieId, String sessionId) {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final bool result = jsonMap['favorite'] as bool;
      return result;
    };

    final result = _get<bool>('/movie/$movieId/account_states', parser,
        <String, dynamic>{'api_key': _apiKey, 'session_id': sessionId});
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

  Future<T> _get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parameters]) async {
    final url = makeUri(path, parameters);

    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());

      //String textResponse=await readResponse(response);
      validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<T> _post<T>(
    String path,
    T Function(dynamic json) parser,
    Map<String, dynamic>? bodyparameters, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = makeUri(path, parameters);

    try {
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyparameters));
      final response = await request.close();
      if (response.statusCode == 201) {
        return 1 as T;
      }

      final json = (await response.jsonDecode());
      validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<String> _makeToken() async {
    https: //www.themoviedb.org/authenticate/{REQUEST_TOKEN}
    final url = makeUri('/authentication/token/new', {'api_key': _apiKey});
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      String token = jsonMap['request_token'] as String;
      return token;
    };
    final result =
        await _get('/authentication/token/new', parser, {'api_key': _apiKey});
    return result;
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      String token = jsonMap['request_token'] as String;
      return token;
    };
    final bodyparameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken
    };
    final result = await _post('/authentication/token/validate_with_login',
        parser, bodyparameters, {'api_key': _apiKey});
    return result;
  }

  Future<int> markAsFavorite(
      {required int accountId,
      required String sessionId,
      required MediaType mediaType,
      required int mediaId,
      required bool favorite}) async {
    final parser = (dynamic json) {
      return 1;
    };
    final bodyparameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': favorite
    };
    final result = await _post(
        '/account/$accountId/favorite',
        parser,
        bodyparameters,
        {'api_key': _apiKey, 'session_id': sessionId.toString()});
    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    https: //www.themoviedb.org/authenticate/{REQUEST_TOKEN}

    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      String sessionId = jsonMap['session_id'] as String;
      return sessionId;
    };
    final bodyParameters = <String, dynamic>{'request_token': requestToken};
    final result = await _post('/authentication/session/new', parser,
        bodyParameters, {'api_key': _apiKey});
    return result;
  }

  Future<String> auth(
      {required String username, required String password}) async {
    final _token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: _token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<int> getAccountInfo(String sessionId) async {
    final parser = (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    };
    final result = await _get(
        '/account', parser, {'api_key': _apiKey, 'session_id': sessionId});
    return result;
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

void validateResponse(HttpClientResponse response, dynamic json) {
  if (response.statusCode == 401) {
    final status = json['status_code'];
    final code = status is int ? status : 0;
    if (code == 30) {
      throw ApiClientException(ApiClientExceptionType.auth);
    } else if (code == 3) {
      throw ApiClientException(ApiClientExceptionType.sessionExpired);
    } else {
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }
}

extension HtttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return await transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
