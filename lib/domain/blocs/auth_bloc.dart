// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:themoviedb/widgets/loader/loader_view_cubit.dart';

import '../api_client/account_api_client.dart';
import '../api_client/auth_api_client.dart';
import '../data_providers/session_data_provider.dart';

abstract class AuthEvent {}

class AuthLogoutEvent extends AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;
  AuthLoginEvent({
    required this.login,
    required this.password,
  });
}

abstract class AuthState {}

class AuthFailureState extends AuthState {
  final Object error;
  AuthFailureState({required this.error});
}

class AuthInProgressState extends AuthState {}

class AuthCheckInProgressState extends AuthState {}

class AuthAuthorizedState extends AuthState {}

class AuthUnauthorizedState extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();
  final AuthApiClient _authApiClient = AuthApiClient();
  final AccountApiClient _accountApiClient = AccountApiClient();

  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLoginEvent) {
        await onAuthLoginEvent(event, emit);
      }

      if (event is AuthLogoutEvent) {
        await onAuthLogoutEvent(event, emit);
      }

      if (event is AuthCheckStatusEvent) {
        await onAuthCheckStatusEvent(event, emit);
      }
    });

    add(AuthCheckStatusEvent());
  }

  Future<void> onAuthCheckStatusEvent(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthInProgressState());
    final sessionId = await _sessionDataProvider.getSessionId();
    final newState =
        sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
    emit(newState);
  }

  Future<void> onAuthLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgressState());

      final sessionId = await _authApiClient.auth(
          username: event.login, password: event.password);
      final accountId = await _accountApiClient.getAccountInfo(sessionId);
      await _sessionDataProvider.setSessionId(sessionId);
      await _sessionDataProvider.setAccountId(accountId);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailureState(error: e));
    }
  }

  Future<void> onAuthLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataProvider.deleteSessionId();
      await _sessionDataProvider.deleteAccountId();
      emit(AuthUnauthorizedState());
    } catch (e) {
      emit(AuthFailureState(error: e));
    }
  }
}
