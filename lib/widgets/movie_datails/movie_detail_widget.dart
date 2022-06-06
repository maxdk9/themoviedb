import 'package:flutter/material.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/movie_detalis_model.dart';
import 'package:themoviedb/model/my_app_model.dart';
import 'package:themoviedb/widgets/movie_datails/movie_datail_info_widget.dart';
import 'package:themoviedb/widgets/movie_datails/movie_detail_cast_widget.dart';

class MovieDetailWidget extends StatefulWidget {
  const MovieDetailWidget({Key? key}) : super(key: key);

  @override
  _MovieDetailWidgetState createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _TitleWidget(),
      ),
      body: const ColoredBox(
          color: Color.fromRGBO(24, 23, 27, 1.0), child: _BodyWidget()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
  }

  @override
  void initState() {
    super.initState();
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    final appModel = Provider.read<MyAppModel>(context);
    model?.onSessionExpired = () => appModel?.resetSession(context);
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);

    return Text(model?.movieDetails?.title ?? 'Loading');
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    if (movieDetails == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: [
          MovieDetailsInfoWidget(),
          SizedBox(
            height: 20,
          ),
          MovieDetailCastWidget(),
        ],
      );
    }
  }
}
