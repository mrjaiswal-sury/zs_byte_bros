import 'package:easycounsellor/services/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();

  String _email = '';
  String _password = '';
  String error = '';
  String _name = '';
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Sign In"),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    child: Tooltip(child: Icon(Icons.person), message: "Register"),
                    onTap: () async {
                      widget.toggleView();
                    },
                  ),
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),

                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            _email = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                        validator: (val) => val.length < 6 ? 'Password should be longer than 6 characters' : null,
                        onChanged: (val) {
                          _password = val;
                        },
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          child: Text("Sign in", style: TextStyle(color: Colors.white),),
                          color: Colors.green,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              print('valid');
                              var result = await _auth.signInWithEmailAndPassword(_email, _password);
                              if (result == null)
                                setState(() {
                                  error = 'Could not sign in';
                                  isLoading = false;
                                });
                            }
                          }),
                      SizedBox(height: 20),
                      Text(error),
                    ],
                  ),
                )),
          );
  }
}
