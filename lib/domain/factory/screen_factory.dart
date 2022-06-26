import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';
import 'package:themoviedb/domain/blocs/movie_list_bloc.dart';
import 'package:themoviedb/domain/blocs/movie_list_cubit.dart';
import 'package:themoviedb/model/movie_list_model.dart';
import '../../model/auth_view_cubit.dart';
import '../../model/movie_detalis_model.dart';
import '../../widgets/auth/auth_widget.dart';
import '../../widgets/loader/loader_view_cubit.dart';
import '../../widgets/loader/loader_widget.dart';
import '../../widgets/main_screen/main_screen_widget.dart';
import '../../widgets/movie_datails/movie_detail_widget.dart';
import '../../widgets/movie_list/movie_list_widget.dart';
import '../../widgets/movie_trailer/movie_trailer_widget.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    // return Provider(
    //   create: (context) => LoaderViewModel(context: context),
    //   child: const LoaderWidget(),
    //   lazy: false,
    // );

    final authBloc = _authBloc ?? AuthBloc(AuthCheckInProgressState());
    _authBloc = authBloc;

    return BlocProvider<LoaderViewCubit>(
        create: ((context) =>
            LoaderViewCubit(LoaderViewCubitState.unknown, authBloc)),
        child: const LoaderWidget()
        );
  }

  Widget makeAuthWidget() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckInProgressState());
    _authBloc = authBloc;

    return BlocProvider<AuthViewCubit>(
      create: (_)=>AuthViewCubit(AuthViewCubitFormFillInProgressState(), authBloc),
      child: const AuthWidget(),
      );


    // return ChangeNotifierProvider(
    //     create: (_) => AuthViewModel(), child: const AuthWidget());
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
    return BlocProvider(
      create: (context) => MovieListCubit( movieListBloc: MovieListBloc(const MovieListState.initial())),
       child: const MovieListWidget());
  }

  Widget makeTVShowWidget() {
    return const TVshowWidget();
  }
}
