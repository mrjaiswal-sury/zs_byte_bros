import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thehappyclub/models/contact.dart';
import 'package:thehappyclub/screens/progress/progress_page.dart';
import 'package:thehappyclub/screens/settings/settings_page.dart';
import 'package:thehappyclub/services/db_service.dart';

import 'chat/chat_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String title = 'Home';
  bool _wantAppbar = true;
  List<Widget> _appBarActions = [];

  static List<Widget> _widgetOptions = <Widget>[ProgressPage(), ChatListPage()];

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    void _onTapped(int index) {
      setState(() {
        _selectedIndex = index;
        switch (index) {
          case 0:
            {
              title = 'Home';
              _wantAppbar = true;
              _appBarActions = [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    child: Tooltip(child: Icon(Icons.settings), message: "Settings"),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(user: user))),
                  ),
                ),
              ];
            }
            break;
          case 1:
            {
              title = 'Chats';
              _wantAppbar = false;
            }
            break;
        }
      });
    }

    return StreamBuilder<Contact>(
        stream: DBService.instance.getUserData(user.uid),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          return Scaffold(
            appBar: _wantAppbar
                ? AppBar(
                    title: Text(title),
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          child: Tooltip(child: Icon(Icons.settings), message: "Settings"),
                          onTap: () => Navigator.push(
                              context, MaterialPageRoute(builder: (context) => SettingsPage(user: user))),
                        ),
                      ),
                    ],
                  )
                : null,
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
                BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Chats"))
              ],
              currentIndex: _selectedIndex,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _onTapped,
            ),
          );
        });
  }
}