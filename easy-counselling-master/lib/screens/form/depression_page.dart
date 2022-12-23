import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehappyclub/services/db_service.dart';
import 'package:thehappyclub/services/db_service.dart';

class DepressionPage extends StatefulWidget {
  FirebaseUser user;

  DepressionPage({this.user});

  @override
  _DepressionPageState createState() => _DepressionPageState();
}

List _questions = [
  "I started doing things slowly than before.",
  "I have lost hope in my future and become pessimistic in life than before.",
  "I wait for the mood to strike me before doing any enjoyable or useful activity but end up doing nothing.\nFor ex. I wait for me to feel like listening to music but that feeling never comes.",
  "I don’t derive satisfaction in any activity.",
  "It is hard for me to concentrate on reading.",
  "The pleasure and joy has gone out of my life.",
  "I have lost interest in aspects of life that used to be interesting to me.",
  "I feel sad and unhappy.",
  "I feel tired and lazy most of the time than before.",
  "Even doing routine things like bathing, taking care of yourself, buying some essential stuffs have become considerably difficult for me.",
  "I feel that I am a guilty person who deserves to be punished.",
  "I feel like a failure.",
  "My sleep has been changed to either too less or more.",
  "I had thoughts of suicide.",
  "I suddenly started avoid people.",
];
int total = 0;
TextTheme _textTheme;

class _DepressionPageState extends State<DepressionPage> {
  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Questionnaire"),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                "Which of these statements do you agree with?",
                style: _textTheme.bodyText1.apply(fontSizeFactor: 1.4, fontWeightDelta: 10),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Expanded(child: _sliderList()),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.done),
        onPressed: () {
          print(total);
          DBService.instance.setDepression(widget.user.uid, total);
          Navigator.pop(context);
        },
      ),
    );
  }
}

Widget _sliderList() {
//  return ListView.builder(                                 //WILL NOT SAVE DATA WHEN SCROLLING.
//    controller: _scrollController,
//    shrinkWrap: true,
//    physics: AlwaysScrollableScrollPhysics(),
//    itemBuilder: (BuildContext context, int index) {
//      return MyWidgetSlider(question: _questions[index], index: index);
//    },
//    itemCount: _questions.length,
//  );

// Beauty in Code
  return SingleChildScrollView(
      child: Column(
    children: <Widget>[
      MyWidgetSlider(question: _questions[0], index: 0),
      MyWidgetSlider(question: _questions[1], index: 1),
      MyWidgetSlider(question: _questions[2], index: 2),
      MyWidgetSlider(question: _questions[3], index: 3),
      MyWidgetSlider(question: _questions[4], index: 4),
      MyWidgetSlider(question: _questions[5], index: 5),
      MyWidgetSlider(question: _questions[6], index: 6),
      MyWidgetSlider(question: _questions[7], index: 7),
      MyWidgetSlider(question: _questions[8], index: 8),
      MyWidgetSlider(question: _questions[9], index: 9),
      MyWidgetSlider(question: _questions[10], index: 10),
      MyWidgetSlider(question: _questions[11], index: 11),
      MyWidgetSlider(question: _questions[12], index: 12),
      MyWidgetSlider(question: _questions[13], index: 13),
      MyWidgetSlider(question: _questions[14], index: 14),
    ],
  ));
}

class MyWidgetSlider extends StatefulWidget {
  final String question;
  final int index;

  MyWidgetSlider({this.question, this.index}) : super();

  _MyWidgetSliderState createState() => _MyWidgetSliderState();
}

class _MyWidgetSliderState extends State<MyWidgetSlider> with SingleTickerProviderStateMixin {
  double _sliderValue;

  @override
  void initState() {
    super.initState();
    if (_sliderValue == null) _sliderValue = 0.0;
  }

  void _setValue(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.question, style: _textTheme.bodyText1),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            (() {
              if (_sliderValue.round() == 0)
                return ('Not at all');
              else if (_sliderValue.round() == 1)
                return ('Slightly');
              else if (_sliderValue.round() == 2)
                return ('Moderately');
              else if (_sliderValue.round() == 3)
                return ('A lot');
              else if (_sliderValue.round() == 4)
                return ('Very much');
              else
                return ('${_sliderValue.round()}');
            })(),
            style: _textTheme.bodyText2,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Expanded(flex: 1, child: Text("1")),
            Expanded(
              flex: 20,
              child: Slider(
                activeColor: Theme.of(context).primaryColor,
                value: _sliderValue,
                onChangeStart: (value) {
                  total -= value.round();
                },
                onChanged: _setValue,
                onChangeEnd: (value) {
                  total += value.round();
                },
                min: 0.0,
                max: 4.0,
                divisions: 4,
              ),
            ),
            //Expanded(flex: 1, child: Text("10")),
          ],
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
