import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/widgets/auth/auth_widget.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainDarkBlue,
      ),

        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey
        )
      ),


      routes: {
        '/auth':(context)=>AuthWidget(),
        '/main_screen':(context)=>MainScreenWidget(),
      },
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(builder: (context){
          return
            Scaffold(
             body:Center(child: Text('Route not found')));
        });
      },
      initialRoute: '/auth',
    );
  }
}


