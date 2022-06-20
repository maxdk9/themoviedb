import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/factory/screen_factory.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/main_screen_model.dart';

class MainScreenWidget extends StatefulWidget {
  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 1;

  final _screenFactory = ScreenFactory();

  @override
  void initState() {
    super.initState();
  }

  

  void onSelectedTab(int index) {
    if (_selectedTab == index) {
      return;
    }
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MainScreenModel? model = NotifierProvider.read<MainScreenModel>(context);
    print(model);
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMDB'),
        actions: [
          IconButton(
              onPressed: () {
                SessionDataProvider().setSessionId(null);
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _screenFactory.makeNewsList(),
          _screenFactory.makeMovieList(),
          _screenFactory.makeTVShowWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
           BottomNavigationBarItem(
              icon: Icon(Icons.fiber_new_sharp), label: 'News'),
           BottomNavigationBarItem(
              icon:  Icon(Icons.movie_filter), label: 'Movies'),
          BottomNavigationBarItem(icon:  Icon(Icons.tv), label: 'TV-show')
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}

class TVshowWidget extends StatelessWidget {
  const TVshowWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('TV-show');
  }
}

class NewsWidget extends StatelessWidget {
  const NewsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('News');
  }
}
