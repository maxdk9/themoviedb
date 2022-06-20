import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/model/movie_detalis_model.dart';
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
        title: const _TitleWidget(),
      ),
      body: const ColoredBox(
          color: Color.fromRGBO(24, 23, 27, 1.0), child: _BodyWidget()),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
        () => context.read<MovieDetailsModel>().setupLocale(context));
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((MovieDetailsModel model) => model.data.title);
    //final model = context.watch<MovieDetailsModel>();

    return Text(title);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((MovieDetailsModel model) => model.data.isLoading);
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: const [
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
