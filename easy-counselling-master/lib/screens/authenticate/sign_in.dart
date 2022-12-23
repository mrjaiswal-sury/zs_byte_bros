import 'package:flutter/material.dart';
import 'package:thehappyclub/screens/authenticate/forgot_password_page.dart';
import 'package:thehappyclub/services/auth.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _deviceHeight;
  var _deviceWidth;
  final AuthService _auth = AuthService();

  String _email = '';
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
      body: Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      autofocus: true,
                      style: _textTheme.bodyText1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "Email", hintStyle: _textTheme.bodyText2),
                      validator: (val) {
                        return val.isEmpty
                            ? 'Enter an email'
                            : val.contains('@vitstudent.ac.in') ? null : 'Enter a valid email';
                      },
                      onChanged: (val) {
                        setState(() {
                          _email = val;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      obscureText: true,
                      style: _textTheme.bodyText1,
                      decoration: InputDecoration(hintText: "Password", hintStyle: _textTheme.bodyText2),
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
                          child: isLoading
                              ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white))
                              : Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 25)),
                          color: Colors.green,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              print('valid');
                              var result = await _auth.signInWithEmailAndPassword(_email, _password);
                              print(result);
                              if (result == null)
                                setState(() {
                                  error = 'Could not sign in';
                                  isLoading = false;
                                });
                              // below check is commented since it can be brute forced
                              else if (result == 'Wrong password') {
                                setState(() {
                                  error = 'Incorrect password.';
                                  isLoading = false;
                                });
                              } else if (result == 'User not found') {
                                setState(() {
                                  error = 'That user does not exist. \n Check if the email entered is correct.';
                                  isLoading = false;
                                });
                              } else {
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
                            "Forgot Password",
                            style: _textTheme.bodyText1.apply(fontSizeFactor: 1.1, color: Colors.pink),
                          ),
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                          }),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: _deviceWidth * 0.75,
                      height: _deviceHeight * 0.06,
                      child: FlatButton(
                          color: Colors.transparent,
                          child: Text(
                            "Register",
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
