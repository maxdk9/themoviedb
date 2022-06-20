import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/model/movie_list_model.dart';
import '../../model/auth_model.dart';
import '../../model/movie_detalis_model.dart';
import '../../widgets/auth/auth_widget.dart';
import '../../widgets/loader/loader_view_model.dart';
import '../../widgets/loader/loader_widget.dart';
import '../../widgets/main_screen/main_screen_widget.dart';
import '../../widgets/movie_datails/movie_detail_widget.dart';
import '../../widgets/movie_list/movie_list_widget.dart';
import '../../widgets/movie_trailer/movie_trailer_widget.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context: context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuthWidget() {
    return ChangeNotifierProvider(
        create: (_) => AuthViewModel(), child: const AuthWidget());
  }

  Widget makeMainScreenWidget() {
    return MainScreenWidget();
  }

  Widget makeMovieDetailsWidget(int movieId) {
    return ChangeNotifierProvider(
        create: (_) => MovieDetailsModel(moveId: movieId),
        child: const MovieDetailWidget());
  }

  Widget makeMovieTrailerWidget(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  Widget makeNewsList() {
    return const NewsWidget();
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider(
        create: (_) => MovieListViewModel(), child: MovieListWidget());
  }

  Widget makeTVShowWidget() {
    return const TVshowWidget();
  }
}
