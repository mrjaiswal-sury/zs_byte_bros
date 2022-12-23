import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehappyclub/screens/form/initial_form_page.dart';
import 'package:thehappyclub/services/auth.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              contentPadding: EdgeInsets.all(10),
              title: Text("Fill out questionnaire"),
              onTap: () async {
                try {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InitialFormPage(user: widget.user)));
                } catch (e) {
                  print(e);
                }
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.all(10),
              title: Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                try {
                  _auth.signOut().then((value) => Navigator.pop(context));
                } catch (e) {
                  print(e);
                }
                deletePrefs();
              },
            ),
          ],
        ));
  }
}
