import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

import 'package:themoviedb/navigation/main_navigation.dart';

import '../widgets/main_screen/main_screen_widget.dart';

class AuthModel extends ChangeNotifier{
  final ApiClient _apiClient=ApiClient();
  final loginTextController=TextEditingController();
  final passwordTextController=TextEditingController();
  String? _errorMessage='';

  bool _isAuthProgress=false;
  bool get canStartAuth=>!_isAuthProgress;
  bool get isAuthProgress=>_isAuthProgress;

  String? get errorMessage=>_errorMessage;

  final SessionDataProvider _sessionDataProvider=SessionDataProvider();
  AuthModel(){
    loginTextController.text='maxdk9';
    passwordTextController.text='dinamo99';
  }

  Future <void> auth(BuildContext context) async{
    final login=loginTextController.text;
    final password=passwordTextController.text;
    if(login.isEmpty||password.isEmpty){
      _errorMessage='Fill login and password';
      notifyListeners();
      return;
    }
    _errorMessage=null;
    _isAuthProgress=true;
     notifyListeners();
     String? sessionId;
     int? accountId;
     try{
       sessionId=await _apiClient.auth(username: login, password: password);
       accountId=await _apiClient.getAccountInfo(sessionId);
     }
     on ApiClientException catch(e){
       switch(e.type){
         case ApiClientExceptionType.network:
           _errorMessage='Server not available';
           break;
         case ApiClientExceptionType.auth:
           _errorMessage='Wrong login or password';
           break;
         case ApiClientExceptionType.other:
           _errorMessage='Server busy, wait and try later';
           break;
       }
     }
     catch(e){
       _errorMessage='Unimplemented error';
     }
     _isAuthProgress=false;
     if(_errorMessage!=null){
       notifyListeners();
       return;
     }

     if(sessionId==null||accountId==null){
       _errorMessage='Undefined error please retry later';
       notifyListeners();
       return;
     }
     else{
       _sessionDataProvider.setSessionId(sessionId);
       _sessionDataProvider.setAccountId(accountId);
       unawaited(Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.mainScreen));

     }


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



