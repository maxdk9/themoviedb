import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

import '../domain/api_client/api_client.dart';
import '../domain/entity/movie.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  late DateFormat _dateFormat = DateFormat.yMMMM();
  String? _locale;
  late int _currentPage;
  late int _totalPage;
  bool _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? searchTimer;

  get movies => _movies;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == null || _locale != locale) {
      _locale = locale;
      _dateFormat = DateFormat.yMMMM(locale);
      await resetList();
    }
  }

  Future<void> resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await loadNextPage();
  }

  Future<PopularMovieResponse> _loadMovies(int page, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularMovie(page, locale);
    } else {
      return await _apiClient.searchMovie(page, locale, query);
    }
  }

  Future<void> loadNextPage() async {
    if (this._isLoadingInProgress || _currentPage >= _totalPage) {
      return;
    }
    this._isLoadingInProgress = true;
    final int nextPage = _currentPage + 1;

    try {
      final moviesResponse = await _loadMovies(nextPage, _locale ?? 'en');
      _currentPage = nextPage;
      _totalPage = moviesResponse.totalPages;
      this._isLoadingInProgress = false;
      _movies.addAll(moviesResponse.movies);
      notifyListeners();
    } catch (e) {
      this._isLoadingInProgress = false;
    }
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  String stringFromDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return _dateFormat.format(date);
  }

  void showMovieAtIndex(int index) {
    if (index < _movies.length - 1) {
      return;
    }
    loadNextPage();
  }

  Future<void> searchMovie(String text) async {
    print('SearchMovie $text');
    searchTimer?.cancel();
    searchTimer = Timer(Duration(seconds: 1), () async {
      final searchQuery = text.isNotEmpty ? text : null;

      if (searchQuery == _searchQuery) {
        return;
      } else {
        _searchQuery = searchQuery;
      }
      await resetList();
    });

    //loadNextPage();
  }
}
