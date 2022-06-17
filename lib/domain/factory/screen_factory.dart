import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/NotifierProvider.dart' as oldProvider;

import '../../model/auth_model.dart';
import '../../model/main_screen_model.dart';
import '../../model/movie_detalis_model.dart';
import '../../widgets/auth/auth_widget.dart';
import '../../widgets/loader/loader_view_model.dart';
import '../../widgets/loader/loader_widget.dart';
import '../../widgets/main_screen/main_screen_widget.dart';
import '../../widgets/movie_datails/movie_detail_widget.dart';
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
    return oldProvider.NotifierProvider(
        create: () => MainScreenModel(), child: MainScreenWidget());
  }

  Widget makeMovieDetailsWidget(int movieId) {
    return oldProvider.NotifierProvider(
        create: () => MovieDetailsModel(moveId: movieId),
        child: const MovieDetailWidget());
  }

  Widget makeMovieTrailerWidget(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }
}
