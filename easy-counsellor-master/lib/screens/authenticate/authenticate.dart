import 'package:easycounsellor/screens/authenticate/register.dart';
import 'package:easycounsellor/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = false;

  //used for user to switch between sign in and register
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn)
      return SignInPage(toggleView: toggleView);
    else
      return RegisterPage(toggleView: toggleView);
  }
}
