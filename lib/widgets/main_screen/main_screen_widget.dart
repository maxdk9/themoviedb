import 'package:flutter/material.dart';
import 'package:themoviedb/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {


  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab=1;



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
    return Scaffold(
      appBar: AppBar(
        title: Text('IMDB'),

      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          Text('News'),
          MovieListWidget(),
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
