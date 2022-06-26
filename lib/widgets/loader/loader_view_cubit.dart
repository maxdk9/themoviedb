import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:themoviedb/domain/blocs/auth_bloc.dart';

enum LoaderViewCubitState { authorized, notauthorized, unknown }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit(initialState, this.authBloc) : super(initialState) {
    
      Future.microtask((() {
        _onState(authBloc.state);
        authBlocSubscription = authBloc.stream.listen(_onState);
        authBloc.add(AuthCheckStatusEvent());
      }));
  
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthUnauthorizedState) {
      emit(LoaderViewCubitState.notauthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
