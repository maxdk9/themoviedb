import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

import '../../domain/data_providers/session_data_provider.dart';

class LoaderViewModel {
  final BuildContext context;
  final AuthService _authService = AuthService();

  LoaderViewModel({required this.context}) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    
    final isAuth = await _authService.isAuth();
    final nextScreen = isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
