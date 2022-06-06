import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/my_app_model.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkAuth();

  const app = MyApp();
  final widget = Provider(model: model, child: app);
  runApp(widget);
}

class MyApp extends StatelessWidget {
  static final MainNavigation mainNavigation = MainNavigation();

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MyAppModel? model = Provider.read<MyAppModel>(context);
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
              unselectedItemColor: Colors.grey)),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ru', ''),
        Locale('en', ''),
      ],
      routes: mainNavigation.routes,
      onGenerateRoute: mainNavigation.onGenerateroute,
      initialRoute: mainNavigation.initialRoute(model?.isAuth == true),
    );
  }
}
