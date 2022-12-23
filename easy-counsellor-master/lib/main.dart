import 'package:easycounsellor/screens/wrapper.dart';
import 'package:easycounsellor/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)); //transparent status bar
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamProvider<FirebaseUser>.value(
          value: AuthService().user,
          builder: (context, snapshot) {
            return Wrapper();
          }),
      theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
    );
  }
}
