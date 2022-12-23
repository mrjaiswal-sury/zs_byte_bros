import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehappyclub/services/db_service.dart';

class PornAddictionPage extends StatefulWidget {
  FirebaseUser user;

  PornAddictionPage({this.user});

  @override
  _PornAddictionPageState createState() => _PornAddictionPageState();
}

int total = 0;
ScrollController _scrollController = ScrollController();
bool _isVisible = true;
SharedPreferences _prefs;
TextTheme _textTheme;

class _PornAddictionPageState extends State<PornAddictionPage> {
  Future getPornAddiction() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Map<String, bool> values = {
    'I daydream about times when I can use porn.': false,
    'I have an addictive nature.': false,
    'I am related to someone who has a porn problem.': false,
    'I maintain a stash of pornography.': false,
    'I turn to porn when I am bored.': false,
    'My friends and contacts are also into pornography.': false,
    'My greatest sexual satisfaction occurs when I am using porn.': false,
    'I use porn when I am feeling distressed and want to feel better.': false,
    'I think about porn images during sex with a real-life partner. ': false,
    'I like porn that features illegal or abusive sexual activities.': false,
    'I arrange my life to make sure I have regular time to be with porn.': false,
    'I make sure I always have access to porn whenever I might want.': false,
    'I am most attracted to people who look like porn stars': false,
    'I need porn as a sexual outlet if I am not in a relationship.': false,
    'I’m uncomfortable with masturbation unless I am using porn or thinking about it. ': false,
    'I prefer using porn alone rather than with a partner. ': false,
    'My sexual interests have become more extreme since using porn.': false,
    'The possibility I could get caught makes porn use more exciting. ': false,
    'I become upset at the thought of giving up porn.': false,
  };

  @override
  void initState() {
    getPornAddiction();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (_isVisible == false) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text("Form")),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Text("Which of these affects you?", style: _textTheme.bodyText1.apply(fontSizeFactor: 1.4)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                controller: _scrollController,
                children: values.keys.map((String key) {
                  return CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text(key),
                    value: values[key],
                    onChanged: (bool value) {
                      setState(() {
                        values[key] = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.done),
          onPressed: () {
            values.forEach((key, value) {
              if (value == true) total += 1;
            });
            print(total);
            DBService.instance.setPornAddiction(widget.user.uid, total);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
