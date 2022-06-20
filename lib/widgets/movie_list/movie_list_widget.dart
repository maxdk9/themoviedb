import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:themoviedb/model/movie_list_model.dart';

import '../../domain/api_client/image_downloader.dart';
import '../../domain/entity/movie.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieListViewModel>().setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [_MovieListWidget(), _SearchWidget()],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieListViewModel model = context.read<MovieListViewModel>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: model.searchMovie,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withAlpha(235),
            border: const OutlineInputBorder()),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieListViewModel model = context.watch<MovieListViewModel>();
    return ListView.builder(
        padding: const EdgeInsets.only(top: 70),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: model.movies.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          model.showMovieAtIndex(index);
          return _MovieListRowWidget(movieIndex: index);
        });
  }
}

class _MovieListRowWidget extends StatelessWidget {
  const _MovieListRowWidget({
    Key? key,
    required this.movieIndex,
  }) : super(key: key);

  final int movieIndex;

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();
    final MovieListRowData movieListRowData = model.movies[movieIndex];
    final posterPath = movieListRowData.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset:const Offset(0, 5))
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (!posterPath.isEmpty)
                  Image.network(ImageDownloader.imageUrl(posterPath)),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movieListRowData.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        movieListRowData.releaseDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movieListRowData.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => model.onMovieTap(context, movieIndex),
            ),
          )
        ],
      ),
    );
  }
}
