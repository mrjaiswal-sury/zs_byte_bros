import 'package:easycounsellor/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  FirebaseUser user;
  SettingsPage({this.user});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  Future deletePrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setDouble('depression', 0);
    _prefs.setDouble('pornAddiction', 0);
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
            child: Text("Sign Out", style: TextStyle(color: Colors.white)),
            color: Colors.red,
            onPressed: () async {
              try {
                _auth.signOut().then((value) => Navigator.pop(context));
              }catch(e){
                print(e);
              }
              deletePrefs();
            })
      ],
    );
  }
}
