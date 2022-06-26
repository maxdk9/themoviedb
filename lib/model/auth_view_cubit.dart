// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:themoviedb/domain/api_client/api_client_exception.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/navigation/main_navigation.dart';
import 'package:themoviedb/widgets/loader/loader_view_cubit.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitFormFillInProgressState &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => 0;
}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String? errorMessage;
  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitErrorState &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitAuthProgressState &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => 0;
}

class AuthViewCubitSuccessAuthState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitSuccessAuthState &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(AuthViewCubitState initialState, this.authBloc)
      : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }

  bool isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    print('authviewcubit login');
    if (!isValid(login, password)) {
      final state = AuthViewCubitErrorState('Fill login and password');
      emit(state);
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      authBlocSubscription.cancel();
      emit(AuthViewCubitSuccessAuthState());
    } else if (state is AuthUnauthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      final errorState = AuthViewCubitErrorState(message);
      emit(errorState);
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Unimplemented error';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Server not available';
      case ApiClientExceptionType.auth:
        return 'Wrong login or password';
      case ApiClientExceptionType.other:
        return 'Server busy, wait and try later';
      default:
        return 'Unimplemented error';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}

// class AuthViewModel extends ChangeNotifier {
//   final AuthService _authService = AuthService();
//   final loginTextController = TextEditingController();
//   final passwordTextController = TextEditingController();
//   String? _errorMessage = '';

//   bool _isAuthProgress = false;

//   bool get canStartAuth => !_isAuthProgress;

//   bool get isAuthProgress => _isAuthProgress;

//   String? get errorMessage => _errorMessage;

//   AuthViewModel() {
//     loginTextController.text = 'maxdk9';
//     passwordTextController.text = 'dinamo99';
//   }

//   bool isValid(String login, String password) =>
//       login.isNotEmpty && password.isNotEmpty;

//   Future<String?> _login(String login, String password) async {
//     try {
//       await _authService.login(login, password);
//     } on ApiClientException catch (e) {
//       switch (e.type) {
//         case ApiClientExceptionType.network:
//           return 'Server not available';
//         case ApiClientExceptionType.auth:
//           return 'Wrong login or password';
//         case ApiClientExceptionType.other:
//           return 'Server busy, wait and try later';
//         default:
//           return 'Unimplemented error';
//       }
//     } catch (e) {
//       return 'Unimplemented error';
//     }
//     return null;
//   }

//   Future<void> auth(BuildContext context) async {
//     final login = loginTextController.text;
//     final password = passwordTextController.text;

//     if (!isValid(login, password)) {
//       _updateStatus('Fill login and password', false);
//       return;
//     }
//     _updateStatus(null, true);
//     _errorMessage = await _login(login, password);

//     if (_errorMessage != null) {
//       _updateStatus(_errorMessage, false);
//       return;
//     } else {
//       //_updateStatus(_errorMessage, true);
//       MainNavigation.resetNavigation(context);
//     }
//   }

//   void _updateStatus(String? errorMessage, bool isAuthProgress) {
//     if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
//       return;
//     }
//     _errorMessage = errorMessage;
//     _isAuthProgress = isAuthProgress;
//     notifyListeners();
//   }
// }

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
