import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/domain/api_client/image_downloader.dart';
import 'package:themoviedb/domain/entity/movie_detail_credits.dart';
import 'package:themoviedb/model/movie_detalis_model.dart';
import 'package:themoviedb/navigation/main_navigation.dart';
import 'package:themoviedb/widgets/tools/radial_percent_widget.dart';

class MovieDetailsInfoWidget extends StatelessWidget {
  const MovieDetailsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: PeopleWidget(),
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview =
        context.select((MovieDetailsModel model) => model.data.overview);

    return Text(overview,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400));
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Overview',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400));
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameData =
        context.select((MovieDetailsModel model) => model.data.nameData);

    return Center(
      child: RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(children: [
            TextSpan(
                text: nameData.name,
                style: const TextStyle(
                    fontSize: 20.85, fontWeight: FontWeight.w600)),
            TextSpan(
                text: nameData.year,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
          ])),
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsModel value) => value.data.summary);

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
        child: Text(
          summary,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final posterData =
        context.select(((MovieDetailsModel model) => model.data.posterData));
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    final favoriteIcon = posterData.favoriteIcon;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(children: [
        if (backdropPath != null)
          Image.network(ImageDownloader.imageUrl(backdropPath)),
        if (posterPath != null)
          Positioned(
              left: 20,
              top: 20,
              bottom: 20,
              child: Image.network(ImageDownloader.imageUrl(posterPath))),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: favoriteIcon,
            onPressed: () {
              model.toggleFavorite(context);
            },
          ),
        )
      ]),
    );
  }
}

class PeopleWidget extends StatelessWidget {
  const PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew =
        context.select((MovieDetailsModel value) => value.data.peopleData);
    if (crew.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _PeopleWidgetRow(employes: crew[0]),
        const SizedBox(
          height: 20,
        ),
        _PeopleWidgetRow(employes: crew[1]),
      ],
    );
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<MovieDetailsMoviePeoplelData> employes;

  const _PeopleWidgetRow({Key? key, required this.employes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: employes
            .map(
              (employee) => _PeopleWidgetRowItem(employee: employee),
            )
            .toList());
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final MovieDetailsMoviePeoplelData employee;

  const _PeopleWidgetRowItem({Key? key, required this.employee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle nameStyle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
    const TextStyle jobStyle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: nameStyle,
          ),
          Text(
            employee.job,
            style: jobStyle,
          )
        ],
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreData =
        context.select((MovieDetailsModel value) => value.data.scoreData);

    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: RadialPercentWidget(
                child: Text(scoreData.voteAverage.toStringAsFixed(0)),
                percent: scoreData.voteAverage / 100,
                fillColor: Colors.brown,
                lineColor: Colors.red,
                freeColor: Colors.yellow,
                lineWidth: 2,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('UserScore')),
          ],
        ),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        if (scoreData.trailerKey != null)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, MainNavigationRouteNames.movieTrailer,
                  arguments: scoreData.trailerKey);
            },
            child: Row(
              children: const [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                Text('Play trailer'),
              ],
            ),
          ),
      ],
    );
  }
}
