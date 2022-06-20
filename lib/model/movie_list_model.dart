// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:themoviedb/domain/services/movie_service.dart';
import 'package:themoviedb/navigation/main_navigation.dart';


import '../domain/entity/movie.dart';
import '../library/paginator.dart';

class MovieListRowData {
  final String title;
  final String releaseDate;
  final String overview;
  final String posterPath;
  final int id;

  MovieListRowData(
      {required this.title,
      required this.releaseDate,
      required this.overview,
      required this.posterPath,
      required this.id});
}

class MovieListViewModel extends ChangeNotifier {
  final _movieService = MovieService();
  late final Paginator<Movie> _moviePaginator;

  late final Paginator<Movie> _searchMoviePaginator;

  Timer? searchTimer;
  String _locale = '';

  var _movies = <MovieListRowData>[];
  late DateFormat _dateFormat = DateFormat.yMMMM();

  String? _searchQuery;

  MovieListViewModel() {
    _moviePaginator = Paginator<Movie>(
      load: (pageNumber) async {
        final result = await _movieService.popularMovie(pageNumber, _locale);
        return PaginatorLoadResult(
            data: result.movies,
            currentPage: result.page,
            totalPage: result.totalPages);
      },
    );
    _searchMoviePaginator = Paginator<Movie>(load: ((pageNumber) async {
      final result = await _movieService.searchMovie(
          pageNumber, _locale, _searchQuery ?? '');
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    }));
  }

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

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
    await _moviePaginator.resetList();
    await _searchMoviePaginator.resetList();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (!isSearchMode) {
      await _moviePaginator.loadNextPage();
      _movies = _moviePaginator.data.map((movie) {
        return makeRowData(movie);
      }).toList();
    } else {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map((movie) {
        return makeRowData(movie);
      }).toList();
    }
    notifyListeners();
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  MovieListRowData makeRowData(Movie movie) {
    return MovieListRowData(
        title: movie.title,
        releaseDate: stringFromDate(movie.releaseDate),
        overview: movie.overview,
        posterPath: movie.poster_path ?? '',
        id: movie.id);
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
    _loadNextPage();
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
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.resetList();
      }
      _loadNextPage();
    });

    //loadNextPage();
  }
}
