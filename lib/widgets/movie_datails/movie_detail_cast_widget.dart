import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/image_downloader.dart';
import 'package:themoviedb/domain/entity/movie_detail_credits.dart';
import '../../library/NotifierProvider.dart';
import '../../model/movie_detalis_model.dart';

class MovieDetailCastWidget extends StatelessWidget {
  const MovieDetailCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Series cast',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(
            height: 250,
            child: Scrollbar(
              child: _ActorListWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Full Cast & Crew',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    var cast = model?.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return SizedBox.shrink();

    
    return ListView.builder(
        itemCount: cast.length,
        itemExtent: 120,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _ActorListItemWidget(
            actorIndex: index,
          );
        });
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;

  const _ActorListItemWidget({Key? key, required this.actorIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    var cast = model?.movieDetails?.credits.cast;
    Actor actor = cast![actorIndex];
    var profilePath = actor.profilePath;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                // ignore: prefer_const_constructors
                offset: Offset(0, 5))
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              profilePath != null
                  ? Image.network(
                      ImageDownloader.imageUrl(profilePath),
                      fit: BoxFit.contain,
                    )
                  : const SizedBox.shrink(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child:
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Text(
                        actor.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        actor.character,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 10),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
