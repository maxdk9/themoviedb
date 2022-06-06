import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie_detail_credits.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/movie_detalis_model.dart';
import 'package:themoviedb/navigation/main_navigation.dart';
import 'package:themoviedb/resources/resources.dart';
import 'package:themoviedb/widgets/tools/radial_percent_widget.dart';

class MovieDetailsInfoWidget extends StatelessWidget {
  const MovieDetailsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =NotifierProvider.watch<MovieDetailsModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopPosterWidget(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: _MovieNameWidget(),
        ),
        const _ScoreWidget(),
        const _SummaryWidget(),
        const Padding(
          padding: const EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        const Padding(
          padding: const EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
    final model =NotifierProvider.watch<MovieDetailsModel>(context);

    return Text(
        model?.movieDetails?.overview??'',
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400)
    );
  }
}


class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Overview',
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400));
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =NotifierProvider.watch<MovieDetailsModel>(context);
    var year =model?.movieDetails?.releaseDate?.year.toString();
    year=year!=null?' $year':'';
    return Center(
      child: RichText(
          textAlign: TextAlign.center,
          maxLines: 3,
          text: TextSpan(children: [
            TextSpan(
                text: model?.movieDetails?.title??'',
                style: const TextStyle(fontSize: 20.85, fontWeight: FontWeight.w600)),
            TextSpan(
                text: ' $year',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
          ])),
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =NotifierProvider.watch<MovieDetailsModel>(context);

    if(model==null){
      return SizedBox.shrink();
    }
    var texts=<String>[];
    var releaseDate=model.movieDetails?.releaseDate;
    if(releaseDate!=null){
      texts.add(model.stringFromDate(releaseDate));
          }
    final productCountries=model.movieDetails?.productionCountries;
    if(productCountries!=null&&productCountries.isNotEmpty){
      texts.add('(${productCountries.first.iso})');
    }
    final runtime=model.movieDetails?.runtime??0;
    final duration=Duration(minutes: runtime);
    final hours=duration.inHours;
    final minutes=duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres=model.movieDetails?.genres;
    if(genres!=null&&genres.isNotEmpty){
      var genresNames=<String>[];
      for(var genre in genres){
        genresNames.add(genre.name);
      }
      final genresString=genresNames.join(', ');
      print(genresString);
      texts.add(genresString);
    }





    return ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
        child: Text(
          texts.join(' '),
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyle(
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

    final model =NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath=model?.movieDetails?.backdropPath;
    final posterPath=model?.movieDetails?.posterPath;
   final isFavorite=model?.isFavorite??false;

    return AspectRatio(
      aspectRatio: 390/219,
      child: Stack(children: [
        backdropPath!=null? Image.network(ApiClient.imageUrl(backdropPath)):SizedBox.shrink(),
        Positioned(
            left: 20,
            top: 20,
            bottom: 20,
            child: posterPath!=null?Image.network(ApiClient.imageUrl(posterPath)):SizedBox.shrink()),
        Positioned(
          top: 10,
          right: 10,
          child:  IconButton(icon: Icon(
              isFavorite ?  Icons.favorite : Icons.favorite_outline
          ),
            onPressed: () {
            model?.toggleFavorite(context);
          },),
        )
      ]),
    );
  }
}






class PeopleWidget extends StatelessWidget {
  const PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model=NotifierProvider.read<MovieDetailsModel>(context);
    var crew=model?.movieDetails?.credits.crew;
    if(crew==null||crew.isEmpty) return SizedBox.shrink();
    crew=crew.sublist(0,crew.length>4?4:crew.length);

    var crew1=crew.where( (el)  {
      var index=crew?.indexOf(el)??0;
      return index%2==0;
    }).toList();

    var crew2=crew.where( (el)  {
      var index=crew?.indexOf(el)??0;
      return index%2!=0;
    }).toList();

    return Column(
      children: [
       const SizedBox(height: 20,),
        _PeopleWidgetRow(employes: crew1),
       const SizedBox(height: 20,),
        _PeopleWidgetRow(employes: crew2),
      ],
    );
  }
}


class _PeopleWidgetRow extends StatelessWidget {

  final List<Employee> employes;

  _PeopleWidgetRow({Key? key,required this.employes}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return
        Row(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: employes.map((employee) => _PeopleWidgetRowItem(employee: employee),
          ).toList()
        );

  }
}


class _PeopleWidgetRowItem extends StatelessWidget {

  final Employee employee;
  const _PeopleWidgetRowItem({Key? key,required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const  TextStyle nameStyle=TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
    const TextStyle jobStyle=TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('${employee.name}',style: nameStyle,), Text('${employee.job}',style: jobStyle,)],
      ),
    );
  }
}



class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model =NotifierProvider.watch<MovieDetailsModel>(context);
    var voteAverage=model?.movieDetails?.voteAverage??0;
    voteAverage=voteAverage*10;
    final videos=model?.movieDetails?.videos.results.where((video) => video.type=='Trailer'&&video.site=='YouTube');
    final trailerKey=videos?.isNotEmpty==true?videos?.first.key:null;

    return Row(
      children: [
        SizedBox(width: 20,),
        Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: RadialPercentWidget(
                child: Text(voteAverage.toStringAsFixed(0)),
                percent: voteAverage/100,
                fillColor: Colors.brown,
                lineColor: Colors.red,
                freeColor: Colors.yellow,
                lineWidth: 2,
              ),
            ),
            TextButton(onPressed: (){}, child: Text('UserScore')),
          ],
        ),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        trailerKey!=null? TextButton(
          onPressed: (){
              Navigator.pushNamed(context, MainNavigationRouteNames.movieTrailer,arguments: trailerKey);
          },
          child: Row(
            children: [
              Icon(Icons.play_arrow,color: Colors.white,),
              Text('Play trailer'),
            ],
          ),
        ):SizedBox.shrink(),
      ],
    );
  }
}
