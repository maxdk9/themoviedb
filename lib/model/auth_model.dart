import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/api_client/api_client_exception.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _errorMessage = '';

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    loginTextController.text = 'maxdk9';
    passwordTextController.text = 'dinamo99';
  }

  bool isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Server not available';
        case ApiClientExceptionType.auth:
          return 'Wrong login or password';
        case ApiClientExceptionType.other:
          return 'Server busy, wait and try later';
        default:
          return 'Unimplemented error';
      }
    } catch (e) {
      return 'Unimplemented error';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!isValid(login, password)) {
      _updateStatus('Fill login and password', false);
      return;
    }
    _updateStatus(null, true);
    _errorMessage = await _login(login, password);

    if (_errorMessage != null) {
      _updateStatus(_errorMessage, false);
      return;
    } else {
      //_updateStatus(_errorMessage, true);
      MainNavigation.resetNavigation(context);
    }
  }

  void _updateStatus(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}

// class AuthProvider extends InheritedNotifier {
//   final AuthModel model;
//
//   const AuthProvider({
//     Key? key,required this.model,
//     required Widget child,
//   }) : super(key: key, child: child,notifier: model);
//
//
//   static AuthProvider? watch(BuildContext context){
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }
//
//   static AuthProvider? read(BuildContext context){
//     final widget=context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
//     return widget is AuthProvider? widget:null;
//   }
//
// }
