import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';

class MovieService{
  final _movieApiClient=MovieApiClient();

  

Future<PopularMovieResponse> popularMovie(int page, String locale) async {
      return await _movieApiClient.popularMovie(page, locale,Configuration.apiKey);
  }

  Future<PopularMovieResponse> searchMovie(int page,String locale, String query) async{
      return await _movieApiClient.searchMovie(page, locale, query,Configuration.apiKey);
  }

}