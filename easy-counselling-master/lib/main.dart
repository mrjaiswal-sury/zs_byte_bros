import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thehappyclub/screens/form/initial_form_page.dart';
import 'package:thehappyclub/screens/wrapper.dart';
import 'package:thehappyclub/services/auth.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color(0xffba68c8))); //transparent status bar
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamProvider<FirebaseUser>.value(
          value: AuthService().user,
          builder: (context, snapshot) {
            return Wrapper();
          }),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xffba68c8),
          scaffoldBackgroundColor: Colors.white,
          unselectedWidgetColor: Colors.grey,
          textTheme: TextTheme(
            bodyText1: Theme.of(context).textTheme.bodyText1.apply(color: Colors.black, fontSizeFactor: 1.3),
            bodyText2: Theme.of(context).textTheme.bodyText2.apply(color: Colors.grey, fontSizeFactor: 1.1),
          ),
          //textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).primaryTextTheme),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xffba68c8),
          bottomAppBarColor: Colors.black,
          scaffoldBackgroundColor: Color(0xff212121),
          unselectedWidgetColor: Colors.grey,
          textTheme: TextTheme(
              bodyText1: Theme.of(context).textTheme.bodyText1.apply(color: Colors.white, fontSizeFactor: 1.3),
              bodyText2: Theme.of(context).textTheme.bodyText2.apply(color: Colors.white54, fontSizeFactor: 1.1)),
          //textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).primaryTextTheme)),
        ));
  }
}
