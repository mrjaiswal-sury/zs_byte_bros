import 'package:flutter/material.dart';
import 'package:thehappyclub/screens/form/initial_form_page.dart';
import 'package:thehappyclub/services/auth.dart';

import '../wrapper.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;

  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _deviceHeight;
  var _deviceWidth;
  final AuthService _auth = AuthService();

  String _email = '';
  String _name = '';
  String _password = '';
  String error = '';
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
//            appBar: AppBar(
//              automaticallyImplyLeading: false,
//              title: Text("Register"),
//              actions: <Widget>[
//                Padding(
//                  padding: EdgeInsets.only(right: 20),
//                  child: GestureDetector(
//                    child: Tooltip(child: Icon(Icons.person), message: "Sign in"),
//                    onTap: () async {
//                      widget.toggleView();
//                    },
//                  ),
//                )
//              ],
//            ),
      body:  Center(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          TextFormField(
                            style: _textTheme.bodyText1,
                            autofocus: true,
                            decoration: InputDecoration(
                                //prefixIcon: Icon(Icons.person, color: Colors.white),
                                hintText: "Name",
                                hintStyle: _textTheme.bodyText2),
                            validator: (val) => val.isEmpty ? 'Enter a name' : null,
                            onChanged: (val) {
                              setState(() {
                                _name = val;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: _textTheme.bodyText1,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                //prefixIcon: Icon(Icons.email, color: Colors.white),
                                hintText: "Email",
                                hintStyle: _textTheme.bodyText2),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Enter an email';
                              } else if (!(val.endsWith('@vitstudent.ac.in') || val.endsWith('@vit.ac.in'))) {
                                return 'Enter your VIT email';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: _textTheme.bodyText1,
                            obscureText: true,
                            decoration: InputDecoration(
                                //prefixIcon: Icon(Icons.lock, color: Colors.white),
                                hintText: "Password",
                                hintStyle: _textTheme.bodyText2),
                            validator: (val) => val.length < 6 ? 'Password should be longer than 6 characters' : null,
                            onChanged: (val) {
                              _password = val;
                            },
                          ),
                          SizedBox(height: 70),
                          SizedBox(
                            width: _deviceWidth * 0.75,
                            height: _deviceHeight * 0.06,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                color: Colors.green,
                                child: isLoading
                                    ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white))
                                    : Text(
                                  "REGISTER",
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                      error = '';
                                    });
                                    var result =
                                        await _auth.registerWithEmailAndPassword(_email, _password, _name, 0, 0);
                                    if (result == null)
                                      setState(() {
                                        error = 'Need valid email and password';
                                        isLoading = false;
                                      });
                                    else if(result == 'User already exists'){
                                      setState(() {
                                        error = 'That email id is already in use.\n Please try a different one.';
                                        isLoading = false;
                                      });
                                    }
                                    else {
                                      setState(() {
                                        isLoading = false;
                                        error = '';
                                      });
                                    }
                                  }
                                }),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: _deviceWidth * 0.75,
                            height: _deviceHeight * 0.06,
                            child: FlatButton(
                                color: Colors.transparent,
                                child: Text(
                                  "Sign In",
                                  style: _textTheme.bodyText1.apply(fontSizeFactor: 1.1),
                                ),
                                onPressed: () async {
                                  widget.toggleView();
                                }),
                          ),
                          SizedBox(height: 20),
                          Text(error, textAlign: TextAlign.center, style: _textTheme.bodyText2.apply(color: Colors.red)),
                        ],
                      ),
                    ),
                  )),
            ),
    );
  }
}
