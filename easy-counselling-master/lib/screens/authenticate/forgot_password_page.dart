import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thehappyclub/services/auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var _deviceHeight;
  var _deviceWidth;
  String _email = '';
  String error = '';
  bool isLoading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    TextTheme _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Enter your email ID", style: _textTheme.bodyText1.apply(fontSizeFactor: 1.2))),
                SizedBox(height: 50),
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
                SizedBox(height: 50),
                SizedBox(
                  width: _deviceWidth * 0.75,
                  height: _deviceHeight * 0.06,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white))
                          : Text("Send Password Reset Email", style: TextStyle(color: Colors.white, fontSize: 20)),
                      color: Colors.green,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          var result = await _auth.resetPassword(_email);
                          if (result == true) {
                            Fluttertoast.showToast(
                                msg: "An email has been sent.",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER);
                            Navigator.pop(context);
                          } else if (result == 'User not found') {
                            setState(() {
                              error = 'That user does not exist. \n Check if the email entered is correct.';
                              isLoading = false;
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }),
                ),
                SizedBox(height: 20),
                Text(error, textAlign: TextAlign.center, style: _textTheme.bodyText2.apply(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
