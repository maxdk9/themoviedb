import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/Theme/button_style.dart';
import 'package:themoviedb/model/auth_view_cubit.dart';
import 'package:themoviedb/navigation/main_navigation.dart';

class _AuthDataStorage {
  String login = '';
  String password = '';
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listener: _onAuthViewCubitStateChange,
      child: Provider(
        create: (context) => _AuthDataStorage(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login to your account'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [const _FormWidget(), _HeaderWidget()],
            ),
          ),
        ),
      ),
    );
  }

  void _onAuthViewCubitStateChange(
      BuildContext context, AuthViewCubitState state) {
    if (state is AuthViewCubitSuccessAuthState) {
      MainNavigation.resetNavigation(context);
    }
  }
}

class _HeaderWidget extends StatelessWidget {
  final TextStyle textStyle =
      const TextStyle(fontSize: 16, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          'In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple. Click here to get started.',
          style: textStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            style: AppButtonStyle.linkButtonStyle,
            onPressed: () {},
            child: const Text('Register')),
        Text(
          'If you signed up but didnt get your verification email, click here to have it resent',
          style: textStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            style: AppButtonStyle.linkButtonStyle,
            onPressed: () {},
            child: const Text('Verify email')),
      ],
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  final TextStyle textStyle =
      const TextStyle(fontSize: 16, color: Color(0xFF212529));

  final InputDecoration textFieldDecoration = const InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    isCollapsed: true,
  );

  @override
  Widget build(BuildContext context) {
    //final model = NotifierProvider.read<AuthViewModel>(context);
    _AuthDataStorage dataStorage = context.read<_AuthDataStorage>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ErrorMessageWidget(),
        Text(
          'UserName',
          style: textStyle,
        ),
        TextField(
          decoration: textFieldDecoration,
          onChanged: (text) => dataStorage.login = text,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        TextField(
          decoration: textFieldDecoration,
          onChanged: (text) => dataStorage.password = text,
          obscureText: true,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(
              width: 30,
            ),
            TextButton(
                style: AppButtonStyle.linkButtonStyle,
                onPressed: () {},
                child: Text('Reset Password')),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthViewCubit>();
    final canStartAuth = (cubit.state is AuthViewCubitFormFillInProgressState ||
        cubit.state is AuthViewCubitErrorState);
    final dataStorage = context.read<_AuthDataStorage>();

    final onPressed1 = canStartAuth
        ? () =>
            cubit.auth(login: dataStorage.login, password: dataStorage.password)
        : null;

    // final model = context.watch<AuthViewModel>();
    final child = cubit.state is AuthViewCubitAuthProgressState
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ))
        : const Text('Login');

    return TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppButtonStyle.frameColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
            )),
        onPressed: onPressed1,
        child: child);
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewCubit cubit) {
      final state = cubit.state;

      if (state is AuthViewCubitErrorState) {
        return state.errorMessage;
      }
      return null;
    });

    // final errorMessage =
    //     context.select((AuthViewModel model) => model.errorMessage);
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red, fontSize: 17.0),
      ),
    );
  }
}
