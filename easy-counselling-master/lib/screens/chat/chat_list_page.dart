import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thehappyclub/models/contact.dart';
import 'package:thehappyclub/models/conversation.dart';
import 'package:thehappyclub/screens/form/initial_form_page.dart';
import 'package:thehappyclub/services/db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  var _deviceHeight;
  var _deviceWidth;
  TextTheme _theme;
  bool _wantCounsellorButton = true;
  bool _wantFormButton = true;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _theme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(title: Text("Chats")),
        body: Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: Column(children: <Widget>[SizedBox(height: 10), Expanded(child: _conversationsListView())])));
  }

  Widget _conversationsListView() {
    return Builder(builder: (context) {
      final user = Provider.of<FirebaseUser>(context);
      return Container(
        child: StreamBuilder<List<ConversationSnippet>>(
            stream: DBService.instance.getUserConversations(user.uid),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Center(child: CircularProgressIndicator());
              else {
                List<ConversationSnippet> _data = snapshot.data;
                if (_data.isEmpty) {
                  return StreamBuilder<Contact>(
                      stream: DBService.instance.getUserData(user.uid),
                      builder: (context, snapshot) {
                        var _data = snapshot.data;
                        List symptoms = [];
                        Future getSymptoms() async {
                          if (_data != null) {
                            try {
                              int depression = _data.depression.round();
                              int pornAddiction = _data.pornAddiction.round();
                              if (depression != 0 || pornAddiction != 0) {
                                symptoms.add(depression);
                                symptoms.add(pornAddiction);
                                return symptoms;
                              } else {
                                print(symptoms);
//                                Fluttertoast.showToast(
//                                    msg: "Please fill out the questionnaire (top right).",
//                                    toastLength: Toast.LENGTH_SHORT,
//                                    gravity: ToastGravity.CENTER,
//                                    timeInSecForIosWeb: 1,
//                                    fontSize: 16.0);
                                return false;
                              }
                            } catch (e) {
                              print(e);
                              return null;
                            }
                          }
                        }

                        getSymptoms();
                        if (snapshot.data == null) return Center(child: CircularProgressIndicator());
                        if (symptoms.isEmpty) {
                          return _wantFormButton == true
                              ? Center(
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("Fill Out Form", style: TextStyle(fontSize: 30, color: Colors.white)),
                                    ),
                                    color: Colors.green,
                                    onPressed: () {
                                      Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => InitialFormPage(user: user)))
                                          .then((value) {
                                        setState(() {
                                          _wantFormButton = false;
                                          _wantCounsellorButton = true;
                                        });
                                      });
                                    },
                                  ),
                                )
                              : Container();
                        }
                        if (snapshot.data.wantCounsellor == true)
                          return Center(
                              child: Text("Please wait a few minutes as a counsellor is assigned.",
                                  style: _theme.bodyText1, textAlign: TextAlign.center,));
                        return _wantCounsellorButton == true
                            ? Center(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Request a counsellor",
                                        style: TextStyle(fontSize: 30, color: Colors.white)),
                                  ),
                                  color: Colors.green,
                                  onPressed: () {
                                    DBService.instance.setCounsellor(user.uid, true);
                                    setState(() {
                                      _wantCounsellorButton = false;
                                    });
                                  },
                                ),
                              )
                            : Container();
                      });
                }
                _data.removeWhere((element) => element.timestamp == null);
                return _data.length != 0
                    ? ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                            conversationID: _data[index].conversationID,
                                            receiverID: _data[index].id,
                                            receiverName: _data[index].name,
                                            receiverImage: _data[index].image,
                                            user: user,
                                          )));
                            },
                            title: Text(_data[index].name, style: _theme.bodyText1),
                            subtitle: _data[index].lastMessage == ""
                                ? Text("Start Talking!",
                                    style: TextStyle(fontWeight: FontWeight.w700, color: _theme.bodyText1.color))
                                : _data[index].lastMessage.length > 50
                                    ? Text(_data[index].lastMessage.substring(0, 50) + "...",
                                        style: _theme.bodyText1.apply(color: Colors.grey, fontSizeFactor: 0.7))
                                    : Text(_data[index].lastMessage,
                                        style: _theme.bodyText1.apply(color: Colors.grey, fontSizeFactor: 0.7)),
                            leading: _data[index].image.isEmpty
                                ? null
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        image: DecorationImage(
                                            fit: BoxFit.cover, image: NetworkImage(_data[index].image))),
                                  ),
                            trailing: listTileTrailing(_data[index].timestamp),
                          );
                        },
                      )
                    : Center(child: Text("No conversations yet!", style: TextStyle(color: Colors.white30)));
              }
            }),
      );
    });
  }

  Widget listTileTrailing(Timestamp timestamp) {
    return Text(timeago.format(timestamp.toDate()), style: TextStyle(fontSize: 15, color: _theme.bodyText1.color));
  }
}
