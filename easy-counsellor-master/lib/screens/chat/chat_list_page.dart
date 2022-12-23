import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easycounsellor/models/conversation.dart';
import 'package:easycounsellor/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  var _deviceHeight;
  var _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

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
                if(_data.isEmpty){
                  print("data is empty");
                  return Center(
                      child: Text("Your cases will appear here.", style: TextStyle(fontSize: 30)),

                  );
                }
                _data.removeWhere((element) => element.timestamp == null);
                print(_data.length);
                return _data.length != 0
                    ? ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          print(_data[index].name);
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
                            title: Text(_data[index].name),
                            subtitle: _data[index].lastMessage == ""
                                ? Text("Start Talking!", style: TextStyle(fontWeight: FontWeight.w700))
                                : _data[index].lastMessage.length > 50
                                    ? Text(_data[index].lastMessage.substring(0, 50) + "...")
                                    : Text(_data[index].lastMessage),
                            leading: _data[index].image.isEmpty ? null : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(_data[index].image))),
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
    return Text(timeago.format(timestamp.toDate()), style: TextStyle(fontSize: 15));
  }
}
