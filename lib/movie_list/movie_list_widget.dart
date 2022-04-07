import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:themoviedb/resources/resources.dart';

import '../movie.dart';


class MovieListWidget extends StatefulWidget {
  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final List<Movie> _movies=[
    Movie(
      title: 'Mortal combat',
      time: 'Arpil 7, 2021',
      description: 'Washed-up MMA fighter Cole Young, unaware of his heritage, and hunted by Emperor Shang Tsung best warrior, Sub-Zero, seeks out and trains with Earth\'s greatest champions as he prepares to stand against the enemies of Outworld in a high stakes battle for the universe.',
      imageName: AppImages.boss
    ),
    Movie(
        title: 'The boss baby',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
    Movie(
        title: 'Back to the future',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
    Movie(
        title: 'The warlord',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
    Movie(
        title: 'Return of jedi',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
    Movie(
        title: 'Old school',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
    Movie(
        title: 'The true grit',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
    Movie(
        title: 'Terminator 2',
        time: 'Arpil 1, 2021',
        description: 'The Templeton brothers — Tim and his Boss Baby little bro Ted — have become adults and drifted away from each other. But a new boss baby with a cutting-edge approach and a can-do attitude is about to bring them together again … and inspire a new family business.',
        imageName: AppImages.boss
    ),
  ];

  var _filteredMovies=<Movie>[];

  final _searchController=TextEditingController();

  void _searchMoves(){
    final query =_searchController.text;
    if(query.isNotEmpty){
      _filteredMovies=_movies.where((element)  {
        return element.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    else{
      _filteredMovies=_movies;
    }
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _filteredMovies=_movies;
   _searchController.addListener(_searchMoves);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(top: 70),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: _filteredMovies.length,
            itemExtent: 163,
            itemBuilder: (BuildContext context, int index) {
              Movie movie=_filteredMovies[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  children: [
                    Container(

                        decoration: BoxDecoration(
                          color: Colors.white,
                                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0,5)
                          )],
                              ),
                          clipBehavior: Clip.hardEdge,
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage(movie.imageName),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    SizedBox(height: 20,),
                                    Text(movie.title,style: TextStyle(fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 5,),
                                    Text(movie.time,style: TextStyle(color: Colors.grey),),
                                    SizedBox(height: 20,),
                                    Text(movie.description,
                                    maxLines: 2,overflow: TextOverflow.ellipsis,)
                                  ],
                                ),
                              ),
                              SizedBox(width: 5,)

                            ],
                          ),
                        ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          print('11');
                        },

                      ),
                    )
                  ],
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(filled: true,fillColor: Colors.white.withAlpha(235),border: OutlineInputBorder()),
          ),
        )
      ],
    );
  }
}
