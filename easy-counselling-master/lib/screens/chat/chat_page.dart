import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:thehappyclub/services/connection_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thehappyclub/models/conversation.dart';
import 'package:thehappyclub/models/message.dart';
import 'package:thehappyclub/services/db_service.dart';
import 'package:bubble/bubble.dart';

class ChatPage extends StatefulWidget {
  final String conversationID;
  final String receiverID;
  final String receiverImage;
  final String receiverName;
  FirebaseUser user;

  ChatPage({this.conversationID, this.receiverName, this.receiverID, this.receiverImage, this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _deviceHeight;
  var _deviceWidth;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _messageText = '';
  ScrollController _listViewController = ScrollController();
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  bool _isThereInternet = true;

  @override
  void initState() {
    super.initState();
    DBService.instance.updateUnseenCount(widget.user.uid, widget.receiverID);
    DBService.instance.updateUserLastSeen(widget.user.uid);
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      if(mounted)
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    if (_source.keys.toList()[0] == ConnectivityResult.none) _isThereInternet = false;
    else _isThereInternet = true;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: widget.receiverImage.isEmpty
              ? null
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.receiverImage))),
                  ),
                ),
          title: Text(widget.receiverName)),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                _messageListView(),
                _isThereInternet == true ?
                Align(alignment: Alignment.bottomCenter, child: _messageField(context)) : Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.8,
      child: StreamBuilder<Conversation>(
          stream: DBService.instance.getConversation(widget.conversationID),
          builder: (context, snapshot) {
            final user = widget.user;
            if (_listViewController.hasClients) {
              Timer(Duration(milliseconds: 50), () {
                _listViewController.jumpTo(_listViewController.position.maxScrollExtent);
              });
            }
            var _conversationData = snapshot.data;
            if (_conversationData != null) {
              if (_conversationData.messages.length != 0) {
                return Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                      controller: _listViewController,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      itemCount: _conversationData.messages.length,
                      itemBuilder: (context, index) {
                        var _message = _conversationData.messages[index];
                        bool isUserMessage = _message.senderID == user.uid;
//                            if (index > 0) {
//                              var currentDate = _message.timestamp.toDate();
//                              var previousDate = _conversationData.messages[index-1].timestamp.toDate();
//                              var difference = currentDate.difference(DateTime());
//                            }
                        return _messageListViewChild(isUserMessage, _message);
                      },
                    )),
                    //SizedBox(height: _deviceHeight * 0.08)
                  ],
                );
              } else {
                return Center(child: Text("Start talking!"));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _messageListViewChild(bool _isUserMessage, Message _message) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: _isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          //_isUserMessage ? Container() : _userImageWidget(),
          SizedBox(width: _deviceWidth * 0.02),
          Expanded(flex: 1, child: _textMessageBubble2(_isUserMessage, _message.content, _message.timestamp))
        ],
      ),
    );
  }

  Widget _userImageWidget() {
    double _imageRadius = _deviceHeight * 0.05;
    return Container(
      height: _imageRadius,
      width: _imageRadius,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.receiverImage))),
    );
  }

  Widget _textMessageBubble2(bool _isUserMessage, String _message, Timestamp _timestamp) {
    return _isUserMessage
        ? Bubble(
            margin: BubbleEdges.only(top: 10),
            alignment: Alignment.topRight,
            nip: BubbleNip.rightBottom,
            color: Colors.green,
            child: Text(_message, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
          )
        : Bubble(
            margin: BubbleEdges.only(top: 10),
            alignment: Alignment.topLeft,
            nip: BubbleNip.leftBottom,
            color: Colors.grey,
            child: Text(_message, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 20)),
          );
  }

  Widget _textMessageBubble(bool _isUserMessage, String _message, Timestamp _timestamp) {
    return Container(
      //height: _deviceHeight * 0.1,
      //width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration:
          BoxDecoration(color: _isUserMessage ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_message, style: TextStyle(color: Colors.white)),
          SizedBox(height: 5),
          Text(
            timeago.format(_timestamp.toDate()),
            style: TextStyle(color: Colors.white30),
          )
        ],
      ),
    );
  }

  Widget _messageField(BuildContext context) {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(color: Colors.grey)),
      margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02, vertical: _deviceHeight * 0.01),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_messageTextField(), _sendMessageButton(context)],
          ),
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.80,
      child: TextFormField(
        autocorrect: true,
        style: TextStyle(fontSize: 20),
        validator: (value) {
          if (value.length == 0) return "Please enter a message";
          return null;
        },
        onChanged: (value) {
          _formKey.currentState.save();
          setState(() {
            _messageText = value;
          });
        },
        decoration: InputDecoration(
            focusColor: Colors.red,
            border: InputBorder.none,
            hintText: "Type a message",
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _sendMessageButton(BuildContext context) {
    final user = widget.user;

    return Container(
      height: _deviceHeight * 0.1,
      width: _deviceWidth * 0.1,
      child: IconButton(
        icon: Icon(Icons.send),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            DBService.instance.updateUnseenCount(widget.user.uid, widget.receiverID);
            DBService.instance.sendMessage(
                widget.conversationID,
                Message(
                  content: _messageText,
                  timestamp: Timestamp.now(),
                  senderID: user.uid,
                  type: MessageType.Text,
                ));
            _formKey.currentState.reset();
            Timer(Duration(milliseconds: 50), () {
              _listViewController.jumpTo(_listViewController.position.maxScrollExtent);
            });
          }
        },
      ),
    );
  }
}
