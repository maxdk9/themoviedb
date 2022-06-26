// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:themoviedb/domain/blocs/movie_list_bloc.dart';

import '../entity/movie.dart';

class MovieListCubitState {
  final List<MovieListRowData> movies;
  final String localeTag;

  MovieListCubitState({
    required this.movies,
    required this.localeTag,
  });

  MovieListCubitState copyWith({
    List<MovieListRowData>? movies,
    String? localeTag,
    String? searchQuery,
  }) {
    return MovieListCubitState(
      movies: movies ?? this.movies,
      localeTag: localeTag ?? this.localeTag,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieListCubitState &&
        listEquals(other.movies, movies) &&
        other.localeTag == localeTag;
  }

  @override
  int get hashCode => movies.hashCode ^ localeTag.hashCode;
}

class MovieListCubit extends Cubit<MovieListCubitState> {
  final MovieListBloc movieListBloc;
  late final StreamSubscription<MovieListState> movieListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  MovieListCubit({required this.movieListBloc})
      : super(
            MovieListCubitState(movies: <MovieListRowData>[], localeTag: "")) {
    Future.microtask(() {
      _onState(movieListBloc.state);
      movieListBlocSubscription = movieListBloc.stream.listen((_onState));
    });
  }

  Future<void> setupLocale(String localeTag) async {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    _dateFormat = DateFormat.yMMMM(localeTag);
    emit(newState);
    movieListBloc.add(MovieListEventLoadReset());
    movieListBloc.add(MovieListEventLoadNextPage(locale: localeTag));
  }

  @override
  Future<void> close() {
    movieListBlocSubscription.cancel();
    return super.close();
  }

  void _onState(MovieListState movieListState) {
    final movies =
        movieListState.movies.map((movie) => makeRowData(movie)).toList();
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void showMovieAtIndex(int index) {
    if (index < state.movies.length - 1) return;
    movieListBloc.add(MovieListEventLoadNextPage(locale: state.localeTag));
  }

  void searchMovie(String text) {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(microseconds: 300), () {
      movieListBloc.add(MovieListEventLoadSearchMovie(query: text));
      movieListBloc.add(MovieListEventLoadNextPage(locale: state.localeTag));
    });
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
}
