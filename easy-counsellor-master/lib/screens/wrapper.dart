import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authenticate/authenticate.dart';
import 'start_page.dart';
import 'home_page.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  Future getStarted() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool result = _prefs.getBool('started');
    if (result == null) return false;
    return true;
  }



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context); // checks if user is logged in. This user is supplied by main.dart
    if (user == null)
      return FutureBuilder(
        future: getStarted(),
        builder: (context, snapshot) {
          if (snapshot.data == true)
            return Authenticate();
          else
            return StartPage();
        },
      );
    else{
      return HomePage();}
  }
}
