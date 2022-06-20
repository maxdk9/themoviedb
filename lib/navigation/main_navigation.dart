import 'package:flutter/material.dart';
import 'package:themoviedb/domain/factory/screen_factory.dart';


abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const auth = 'auth';
  static const mainScreen = '/main_screen';
  static const movieDetails = '/main_screen/movie_details';
  static const movieTrailer = '/main_screen/movie_details/movie_trailer';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigationRouteNames.loaderWidget: (context) =>
        _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (context) => _screenFactory.makeAuthWidget(),
    MainNavigationRouteNames.mainScreen: (context) =>
        _screenFactory.makeMainScreenWidget(),
  };

  Route<Object> onGenerateroute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => _screenFactory.makeMovieDetailsWidget(movieId),
        );

      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
            builder: (context) =>
                _screenFactory.makeMovieTrailerWidget(youtubeKey));
      default:
        print('error navigation');
        const widget = Text('Navigation Error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }

  static void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.loaderWidget, (route) => false);
  }
}
