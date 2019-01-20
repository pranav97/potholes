import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

class SubmitView extends StatefulWidget {
  SubmitView({Key key}) : super(key: key);

  @override
  _SubmitViewState createState() => _SubmitViewState();
}

class _SubmitViewState extends State<SubmitView> {
  int _radioValue = 0;
  double _sliderValue = 10.0;
  List<String> roadProblems = ['Potholes', 'Bumpy', 'Poorly Paved', 'Litter',
    'Spillage', 'Broken Barrier', 'Slippery When Wet', 'Other'];

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _submitForm() {
    var url = "http://169.233.126.136/issues";
    var roadProblem  = roadProblems[_radioValue];

    if (_radioValue == 7)
      roadProblem = textController.text;

    var data = JsonEncoder().convert({'types': roadProblem,
      'longitude': LocationHolder.location.longitude.toString(),
      'latitude': LocationHolder.location.latitude.toString(),
      'severity': _sliderValue
    });

    http.post(url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: data
    ).then((response) {
      print("Response body: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text('Successfully Submitted!'),
              titlePadding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 20.0, bottom: 20.0),
            );
          }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 120.0, top: 30.0, bottom: 15.0),
              child: Text(
                'Road Problem:',
                style: TextStyle(fontSize: 20.0),
              )
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 40.0
                ),
                child: new Row(
                  children: <Widget> [
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),

                    new Text('${roadProblems[0]}'),
                  ]
                )
              ),

              new Radio(
                value: 4,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('${roadProblems[4]}')
            ],
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 52.0
                ),
                child: new Row(
                  children: <Widget> [
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),

                    new Text('${roadProblems[1]}'),
                  ]
                )
              ),

              new Radio(
                value: 5,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('${roadProblems[5]}')
            ],
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 15.0
                ),
                child: new Row(
                  children: <Widget> [
                    new Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),

                    new Text('${roadProblems[2]}'),
                  ]
                )
              ),

              new Radio(
                value: 6,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('${roadProblems[6]}')
            ],
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 64.0
                ),
                child: new Row(
                  children: <Widget> [
                    new Radio(
                      value: 3,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),

                    new Text('${roadProblems[3]}'),
                  ]
                )
              ),

              new Radio(
                value: 7,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Flexible(
                child: new TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Other',
                  ),
                  controller: textController,
                )
              )
            ],
          ),

          new Padding(
              padding: const EdgeInsets.only(left: 100.0, top: 30.0, bottom: 15.0),
              child: Text(
                'Severity of Problem:',
                style: TextStyle(fontSize: 20.0),
              )
          ),

          new Slider(
            activeColor: Colors.lightBlueAccent,
            min: 0.0,
            max: 10.0,
            onChanged: (severity) {
              setState(() => _sliderValue = severity);
            },
            value: _sliderValue,
          ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.only(right: 100.0),
                  child: Text('Moderate')
              ),

              Text(
                '${_sliderValue.toInt()}',
                style: TextStyle(fontSize: 20.0)
              ),

              new Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: Text('Extreme')
              ),
            ],
          ),

          new Padding(
            padding: const EdgeInsets.all(30.0),
            child: RaisedButton(
              onPressed: _submitForm,
              color: Colors.blue,
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white)
              ),
            ),
          )
        ]
    );
  }
}
