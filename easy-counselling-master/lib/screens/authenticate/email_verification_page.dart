import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thehappyclub/services/auth.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthService _auth = AuthService();
  var _deviceHeight;
  var _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    TextTheme _textTheme = Theme.of(context).textTheme;

    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "An email has been sent to ${user.email}.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 10),
          Text(
            "Please verify your account.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 10),
          Text(
            "Already verified? Please wait a short while.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 30),
          SizedBox(
            width: _deviceWidth * 0.75,
            height: _deviceHeight * 0.06,
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                color: Colors.green,
                child: Text(
                  "SIGN OUT",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                onPressed: () async {
                  await _auth.signOut();
                }),
          ),
          SizedBox(
            width: _deviceWidth * 0.75,
            height: _deviceHeight * 0.06,
            child: FlatButton(
                color: Colors.transparent,
                child: Text(
                  "Send again",
                  style: _textTheme.bodyText1.apply(fontSizeFactor: 1.1),
                ),
                onPressed: () async {
                  _auth.sendEmailVerification(user);
                }),
          ),
        ],
      ),
    ));
  }
}
