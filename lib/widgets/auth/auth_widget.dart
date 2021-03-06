import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/button_style.dart';
import 'package:themoviedb/library/NotifierProvider.dart';
import 'package:themoviedb/model/auth_model.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build auth widget');
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to your account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [_FormWidget(), _HeaderWidget()],
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final TextStyle textStyle = TextStyle(fontSize: 16, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
        ),
        Text(
          'In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple. Click here to get started.',
          style: textStyle,
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
            style: AppButtonStyle.linkButtonStyle,
            onPressed: () {},
            child: Text('Register')),
        Text(
          'If you signed up but didnt get your verification email, click here to have it resent',
          style: textStyle,
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
            style: AppButtonStyle.linkButtonStyle,
            onPressed: () {},
            child: Text('Verify email')),
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
    final model = NotifierProvider.read<AuthModel>(context);

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
          controller: model?.loginTextController,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        TextField(
          decoration: textFieldDecoration,
          controller: model?.passwordTextController,
          obscureText: true,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            _AuthButtonWidget(),
            SizedBox(
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
    final model = NotifierProvider.watch<AuthModel>(context);
    final child = model?.isAuthProgress == true
        ? SizedBox(
            width: 15,
            height: 15,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ))
        : const Text('Login');

    return TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppButtonStyle.frameColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            textStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
            )),
        onPressed: () =>
            model?.canStartAuth == true ? model?.auth(context) : null,
        child: child);
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watch<AuthModel>(context)?.errorMessage;
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 17.0),
      ),
    );
  }
}
