import 'package:flutter/material.dart';

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Placeholder Settings"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Go back"),
        )
      ),
    );
  }
}