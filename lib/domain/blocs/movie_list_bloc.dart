// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';

import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';

import '../api_client/api_client.dart';
import '../entity/movie.dart';

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

abstract class MovieListEvent {}

class MovieListEventLoadNextPage extends MovieListEvent {
  final String locale;
  MovieListEventLoadNextPage({
    required this.locale,
  });
}

class MovieListEventLoadReset extends MovieListEvent {}

class MovieListEventLoadSearchMovie extends MovieListEvent {
  final String query;

  MovieListEventLoadSearchMovie({required this.query});
}

class MovieListContainer {
  const MovieListContainer.initial()
      : movies = const <Movie>[],
        currentPage = 0,
        totalPage = 1;

  final List<Movie> movies;
  final int currentPage;
  final int totalPage;

  MovieListContainer({
    required this.movies,
    required this.currentPage,
    required this.totalPage,
  });

  bool get isComplete => currentPage >= totalPage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieListContainer &&
        listEquals(other.movies, movies) &&
        other.currentPage == currentPage &&
        other.totalPage == totalPage;
  }

  @override
  int get hashCode =>
      movies.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  MovieListContainer copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? totalPage,
  }) {
    return MovieListContainer(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class MovieListState {
  final MovieListContainer popularMovieContainer;
  final MovieListContainer searchMovieContainer;
  final String searcQuery;

  const MovieListState.initial()
      : popularMovieContainer = const MovieListContainer.initial(),
        searchMovieContainer = const MovieListContainer.initial(),
        searcQuery = '';

  MovieListState({
    required this.popularMovieContainer,
    required this.searchMovieContainer,
    required this.searcQuery,
  });

  List<Movie> get movies =>
      isSearchMode ? searchMovieContainer.movies : popularMovieContainer.movies;

  bool get isSearchMode {
    return searcQuery.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieListState &&
        other.popularMovieContainer == popularMovieContainer &&
        other.searchMovieContainer == searchMovieContainer &&
        other.searcQuery == searcQuery;
  }

  @override
  int get hashCode =>
      popularMovieContainer.hashCode ^
      searchMovieContainer.hashCode ^
      searcQuery.hashCode;

  MovieListState copyWith({
    MovieListContainer? popularMovieContainer,
    MovieListContainer? searchMovieContainer,
    String? searcQuery,
  }) {
    return MovieListState(
      popularMovieContainer:
          popularMovieContainer ?? this.popularMovieContainer,
      searchMovieContainer: searchMovieContainer ?? this.searchMovieContainer,
      searcQuery: searcQuery ?? this.searcQuery,
    );
  }
}

typedef NextPageLoader = Future<PopularMovieResponse> Function(int nextPage);

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final _movieApiClient = MovieApiClient();

  MovieListBloc(MovieListState initialState) : super(initialState) {
    on<MovieListEvent>((event, emit) async {
      if (event is MovieListEventLoadNextPage) {
        MovieListState? newState=await onMovieListEventLoadNextPage(event, emit);
        if(newState!=null){
          emit(newState);
        }
      }
      if (event is MovieListEventLoadReset) {
        onMovieListEventReset(event, emit);
      }
      if (event is MovieListEventLoadSearchMovie) {
         onMovieListEventSearchMovie(event, emit);
      }
    });
  }

  Future<MovieListState?> onMovieListEventLoadNextPage(
      MovieListEventLoadNextPage event, Emitter<MovieListState> emit) async {
    if (state.isSearchMode) {
      final container =
          await _loadNextPage(state.searchMovieContainer, (nextPage) async {
        final result = await _movieApiClient.searchMovie(
            nextPage, event.locale, state.searcQuery, Configuration.apiKey);
        return result;
      });
      if (container != null) {
        final newState = state.copyWith(searchMovieContainer: container);
        //emit(newState);
        return newState;
      }
    } else {
      final container =
          await _loadNextPage(state.popularMovieContainer, (nextPage) async {
        final result = await _movieApiClient.popularMovie(
            nextPage, event.locale, Configuration.apiKey);
        return result;
      });
      if (container != null) {
        final newState = state.copyWith(popularMovieContainer: container);
        //emit(newState);
        return newState;
      }
    }
    return null;
  } //await _searchMoviePaginator.loadNextPage();

  Future<MovieListContainer?> _loadNextPage(
      MovieListContainer container, NextPageLoader loader) async {
    if (container.isComplete) return null;

    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final movies = List<Movie>.from(container.movies)..addAll(result.movies);
    //final movies = container.movies..addAll(result.movies);

    final newContainer = container.copyWith(
        movies: movies, currentPage: result.page, totalPage: result.totalPages);
    return newContainer;
  }

  Future<void> onMovieListEventReset(
      MovieListEventLoadReset event, Emitter<MovieListState> emit) async {
    emit(const MovieListState.initial());
  }

  Future<void> onMovieListEventSearchMovie(
      MovieListEventLoadSearchMovie event, Emitter<MovieListState> emit) async {
    if (state.searcQuery == event.query) return;

    final newState = state.copyWith(
        searcQuery: event.query,
        searchMovieContainer: const MovieListContainer.initial());
    emit(newState);
  }
}
