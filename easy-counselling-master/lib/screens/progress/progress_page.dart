import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    final user = Provider.of<FirebaseUser>(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Motivational Content", style: _textTheme.bodyText1.apply(fontSizeFactor: 2.0)),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              //padding: EdgeInsets.all(10),
              //decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(20))),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[Text("Insert videos here.", style: _textTheme.bodyText1)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
