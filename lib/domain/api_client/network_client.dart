import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/api_client_exception.dart';

class NetworkClient {
  final _client = HttpClient();

  Uri makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('${Configuration.host}$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    }
    return uri;
  }

  Future<T> get<T>(String path, T Function(dynamic json) parser,
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

  Future<T> post<T>(
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
}

extension HtttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return await transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
