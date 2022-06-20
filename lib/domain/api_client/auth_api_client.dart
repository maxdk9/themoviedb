import '../../configuration/configuration.dart';
import 'network_client.dart';

class AuthApiClient {
  final _networkClient = NetworkClient();

  Future<String> _makeSession({required String requestToken}) async {
    //https: //www.themoviedb.org/authenticate/{REQUEST_TOKEN}

    parser (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      String sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }
    final bodyParameters = <String, dynamic>{'request_token': requestToken};
    final result = await _networkClient.post('/authentication/session/new',
        parser, bodyParameters, {'api_key': Configuration.apiKey});
    return result;
  }

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  

  Future<String> _makeToken() async {
    //https: //www.themoviedb.org/authenticate/{REQUEST_TOKEN}
    // final url = _networkClient.makeUri(
    //     '/authentication/token/new', {'api_key': Configuration.apiKey});
    parser (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      String token = jsonMap['request_token'] as String;
      return token;
    }
    final result = await _networkClient.get(
        '/authentication/token/new', parser, {'api_key': Configuration.apiKey});
    return result;
  }

  Future<String> _validateUser(
      {required String username,
      required String password,
      required String requestToken}) async {
    parser (dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      String token = jsonMap['request_token'] as String;
      return token;
    }
    final bodyparameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken
    };
    final result = await _networkClient.post(
        '/authentication/token/validate_with_login',
        parser,
        bodyparameters,
        {'api_key': Configuration.apiKey});
    return result;
  }
}
