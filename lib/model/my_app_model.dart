import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

class MyAppModel {
  bool _isAuth=false;
  bool get isAuth=>_isAuth;

  Future<void> checkAuth() async{
    final sessionId =await sessionDataProvider.getSessionId();
    _isAuth=sessionId!=null;
  }
  final SessionDataProvider sessionDataProvider=SessionDataProvider();

  Future<void> resetSession(BuildContext context) async{
    await sessionDataProvider.setSessionId(null);
    await sessionDataProvider.setAccountId(null);
    await Navigator.of(context).pushNamedAndRemoveUntil(MainNavigationRouteNames.auth,
            (route) => false);
  }
}