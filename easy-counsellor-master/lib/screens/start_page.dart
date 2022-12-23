import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authenticate/authenticate.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with AutomaticKeepAliveClientMixin<StartPage> {
  PageController _pageController = PageController(initialPage: 0, keepPage: true);
  GlobalKey<PageContainerState> _pageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                    return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Authenticate(),
                        ));
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
