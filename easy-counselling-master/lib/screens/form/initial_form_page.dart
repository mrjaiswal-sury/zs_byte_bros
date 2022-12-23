import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehappyclub/screens/form/depression_page.dart';
import 'package:thehappyclub/screens/form/porn_addiction_page.dart';

import '../home_page.dart';

class InitialFormPage extends StatefulWidget {

  FirebaseUser user;
  InitialFormPage({this.user});
  @override
  _InitialFormPageState createState() => _InitialFormPageState();
}

class _InitialFormPageState extends State<InitialFormPage> with TickerProviderStateMixin{


  Map<String, bool> values = {
    'Depression': false,
    'Porn Addiction': false,
  };
  String _error = '';


  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Form")),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text("Which of these affects you?",  style: _textTheme.bodyText1.apply(fontSizeFactor: 1.4)),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(
                  children: values.keys.map((String key) {
                    return CheckboxListTile(
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(key),
                      value: values[key],
                      onChanged: (bool value) {
                        setState(() {
                          values[key] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(flex: 1,child: Text(_error, style: TextStyle(color: Colors.red, fontSize: 20)))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.done),
        onPressed: () {
          if (values['Depression'] == true)
            Navigator.push(context, MaterialPageRoute(builder: (context) => DepressionPage(user: widget.user))).then((value) {
              if (values['Porn Addiction'] == true) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PornAddictionPage(user: widget.user))).then((value) {
                  Navigator.pop(context);
                });
              }
              else
                Navigator.pop(context);
            });
          else if(values['Porn Addiction'] == true)
            Navigator.push(context, MaterialPageRoute(builder: (context) => PornAddictionPage(user: widget.user))).then((value) {
              Navigator.pop(context);
            });
          else
            setState(() {
              _error = 'Please pick at least one option';
            });
        },
      ),
    );
  }
}
