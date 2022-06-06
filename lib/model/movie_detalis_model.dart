import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final int moveId;
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
    await loadDetails();
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    final newfavorite = !_isFavorite;
    if (sessionId != null && accountId != null) {
      _isFavorite = newfavorite;
      notifyListeners();
      try {
        await _apiClient.markAsFavorite(
            accountId: accountId,
            sessionId: sessionId,
            mediaType: MediaType.Movie,
            mediaId: this.moveId,
            favorite: newfavorite);
      } on ApiClientException catch (e) {
        _handleApiClientException(e);
      }
    }
  }

  Future<void> loadDetails() async {
    try {
      _movieDetails = await _apiClient.movieDetails(this.moveId, this._locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isFavorite(this.moveId, sessionId);
        notifyListeners();
      }
    } on ApiClientException catch (e) {
     _handleApiClientException(e);
    }
  }

  void _handleApiClientException(ApiClientException e) {
    switch (e.type) {
      case ApiClientExceptionType.sessionExpired:
        onSessionExpired?.call();
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
