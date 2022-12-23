import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehappyclub/screens/authenticate/register.dart';
import 'package:thehappyclub/screens/authenticate/sign_in.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> with AutomaticKeepAliveClientMixin<Authenticate>{

  bool showSignIn;

  Future getStarted() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool result = _prefs.getBool('started');
    if (result == null) {
      print('1st time');
    } else
      setState(() {
        showSignIn = false;
      });
  }

  //used for user to switch between sign in and register
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  void initState() {
    getStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    PageController _pageController = PageController(initialPage: 0, keepPage: true);
    GlobalKey<PageContainerState> _pageKey = GlobalKey();

    if(showSignIn == true)
      return SignInPage(toggleView: toggleView);
    if(showSignIn == false)
      return RegisterPage(toggleView: toggleView);

    return Scaffold(
        body: PageIndicatorContainer(
          key: _pageKey,
          align: IndicatorAlign.bottom,
          length: 4,
          indicatorSpace: 10,
          indicatorSelectorColor: Colors.black,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Page 1",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              Container(
                color: Colors.orange,
                child: Center(
                  child: Text(
                    "Page 2",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Page 3",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              Container(
                color: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Page 4",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    SizedBox(height: 50),
                    IconButton(
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('started', true);
                        setState(() {
                          showSignIn = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
