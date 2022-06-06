import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/main_screen_model.dart';
import 'package:themoviedb/model/movie_detalis_model.dart';
import 'package:themoviedb/widgets/movie_trailer/movie_trailer_widget.dart';

import '../model/auth_model.dart';
import '../widgets/auth/auth_widget.dart';
import '../widgets/main_screen/main_screen_widget.dart';
import '../widgets/movie_datails/movie_detail_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
  static const movieTrailer = '/movie_trailer';
}

class MainNavigation {
  String initialRoute(bool isAuth) {
    return isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
  }

  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteNames.auth: (context) =>
        NotifierProvider(create: () => AuthModel(), child: const AuthWidget()),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
        create: () => MainScreenModel(), child: MainScreenWidget()),
  };

  Route<Object> onGenerateroute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
              create: () => MovieDetailsModel(moveId: movieId),
              child: const MovieDetailWidget()),
        );

      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
            builder: (context) => MovieTrailerWidget(youtubeKey: youtubeKey));
      default:
        print('error navigation');
        const widget = Text('Navigation Error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
