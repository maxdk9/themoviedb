import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

void main() {
  
  const app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  static final MainNavigation mainNavigation = MainNavigation();

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.mainDarkBlue,
          ),
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: AppColors.mainDarkBlue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey)),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''),
        Locale('en', ''),
      ],
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateroute,
      initialRoute: MainNavigationRouteNames.loaderWidget,
    );
  }
}
