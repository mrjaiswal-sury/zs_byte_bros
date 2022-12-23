import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file:///C:/Users/ishan/AndroidStudioProjects/TheHappyClub/the_happy_club/lib/screens/authenticate/email_verification_page.dart';
import 'package:thehappyclub/services/auth.dart';
import 'authenticate/authenticate.dart';
import 'home_page.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoading;
  bool _isThereInternet;
  bool _isEmailVerified;
  final AuthService _auth = AuthService();
  Timer _timer;
  SharedPreferences _prefs;

  Future _checkInternetConnectivity() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none)
      return false;
    else if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) return true;
  }

  Future _checkEmailVerification() async {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser()
        ..reload();
      var user = await FirebaseAuth.instance.currentUser();
      if (user.isEmailVerified) {
        setState(() {
          _prefs.setBool('verified', true);
          _isEmailVerified = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _checkInternetConnectivity().then((value) {
      _isThereInternet = value;
      _isEmailVerified = _prefs.getBool('verified');
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context); // checks if user is logged in. This user is supplied by main.dart
    if (_isLoading == true) return Center(child: CircularProgressIndicator());

//    if(_isThereInternet == false) {
//      return Scaffold(
//        body: Center(
//          child: Text("You have no internet."),
//        ),
//      );
//    }

    if (user == null) {
      return Authenticate();
    } else {
      if (_isEmailVerified != true) _checkEmailVerification();
      if (_isEmailVerified == true) {
        return HomePage();
      } else {
        return EmailVerificationPage();
      }
    }
  }
}
