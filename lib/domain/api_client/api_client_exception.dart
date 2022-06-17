enum ApiClientExceptionType { network, auth, sessionExpired, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}