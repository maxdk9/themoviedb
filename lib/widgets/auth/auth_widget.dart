import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/button_style.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';



class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        SizedBox(height: 10,),
        TextButton(
          style: AppButtonStyle.linkButtonStyle,
            onPressed: (){}, child: Text('Register')),
        Text(
          'If you signed up but didnt get your verification email, click here to have it resent',
          style: textStyle,
        ),
        SizedBox(height: 10,),
        TextButton(
          style: AppButtonStyle.linkButtonStyle,
            onPressed: (){}, child: Text('Verify email')),
      ],
    );
  }
}

class _FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  final _loginTextController=TextEditingController(text: 'admin');
  final _passwordTextController=TextEditingController(text: 'admin');
  String? errorText=null;

  void _auth(){
    print('auth');
    final login=_loginTextController.text;
    final password=_passwordTextController.text;
    if(login=='admin'&&password=='admin'){
      errorText=null;
      Navigator.of(context).pushNamed('/main_screen');
      
    }
    else{
      errorText="Incorrect login or password";
    }
    setState(() {
    });
  }

  void _resetPassword(){
    print('reset password');
  }

  final TextStyle textStyle =
      const TextStyle(fontSize: 16, color: Color(0xFF212529));

  final InputDecoration textFieldDecoration = const InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    isCollapsed: true,
  );
  @override
  Widget build(BuildContext context) {
    final errorText=this.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(errorText!=null)  Text(errorText,style: TextStyle(color:Colors.red,fontSize: 17.0),),

        Text(
          'UserName',
          style: textStyle,
        ),
        TextField(
          decoration: textFieldDecoration,
          controller: _loginTextController,
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
          controller: _passwordTextController,
          obscureText: true,
        ),
        SizedBox(height: 30,),
        Row(
          children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppButtonStyle.frameColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                    )),
                onPressed: _auth,
                child: Text('Login')),
            SizedBox(width: 30,),
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


