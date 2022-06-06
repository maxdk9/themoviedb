import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/main_screen_model.dart';
import 'package:themoviedb/model/movie_list_model.dart';

import '../movie_list/movie_list_widget.dart';


class MainScreenWidget extends StatefulWidget {


  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab=1;

  final MovieListModel movieListModel=MovieListModel();


  @override
  void initState() {
    super.initState();


  }


  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
    movieListModel.loadNextPage();
  }

  void onSelectedTab(int index){
    if(_selectedTab==index){
      return;
    }
    setState(() {
      _selectedTab=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    MainScreenModel? model=NotifierProvider.read<MainScreenModel>(context);
    print(model);
    return Scaffold(
      appBar: AppBar(
        title: Text('IMDB'),
        actions: [
          IconButton(onPressed: (){
            SessionDataProvider().setSessionId(null);
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          Text('News'),
          NotifierProvider(
              create: ()=>movieListModel,isManagingModel: false
              ,child: MovieListWidget()),
          Text('TV-show'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(
            Icons.fiber_new_sharp
          ),
          label: 'News'),
          BottomNavigationBarItem(icon: Icon(
            Icons.movie_filter
          ),
            label: 'Movies'
          ),
          BottomNavigationBarItem(icon: Icon(
              Icons.tv
          ),
              label: 'TV-show'
          )
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
