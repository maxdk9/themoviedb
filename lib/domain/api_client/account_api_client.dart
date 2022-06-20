import 'package:themoviedb/domain/api_client/network_client.dart';

import '../../configuration/configuration.dart';



enum MediaType {
  movie,
  tv,
}

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

class AccountApiClient{
  final _networkClient=NetworkClient();

  Future<int> getAccountInfo(String sessionId) async {
    parser (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }
    final result = await _networkClient.get('/account', parser,
        {'api_key': Configuration.apiKey, 'session_id': sessionId});
    return result;
  }

  Future<int> markAsFavorite(
      {required int accountId,
      required String sessionId,
      required MediaType mediaType,
      required int mediaId,
      required bool favorite}) async {
    parser(dynamic json) {
      return 1;
    }
    final bodyparameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': favorite
    };
    final result = await _networkClient.post(
        '/account/$accountId/favorite',
        parser,
        bodyparameters,
        {'api_key': Configuration.apiKey, 'session_id': sessionId.toString()});
    return result;
  }
}