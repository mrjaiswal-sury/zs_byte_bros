import 'package:easycounsellor/models/contact.dart';
import 'package:easycounsellor/screens/progress/progress_page.dart';
import 'package:easycounsellor/screens/settings/settings_page.dart';
import 'package:easycounsellor/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SettingsPage(user: user),
            );
          });
    }

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
                      child: Tooltip(child: Icon(Icons.settings), message: "Settings"), onTap: showSettingsPanel),
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
          var _data = snapshot.data;

          return Scaffold(
            appBar: _wantAppbar
                ? AppBar(
                    title: Text(title),
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                            child: Tooltip(child: Icon(Icons.settings), message: "Settings"), onTap: showSettingsPanel),
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
              selectedItemColor: Colors.blue[800],
              onTap: _onTapped,
            ),
          );
        });
  }
}
