import 'package:flutter/material.dart';
import 'map_view.dart';

void main() => runApp(TabBarController());

class TabBarController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "View Map"),
                Tab(text: "Submit"),
              ],
            ),
            title: Text('Potfolio'),
          ),
          body: TabBarView(
            children: [
              MapView(),
              SubmitPage(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
