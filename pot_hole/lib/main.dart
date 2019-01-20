import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'map_view.dart';
import 'submit_view.dart';

void main() => runApp(TabBarController());


class LocationHolder {
  static LatLng location = LatLng(100, 100);
  static bool hasInit = false;
}

class TabBarController extends StatelessWidget {
  TabBarController() : super() {
    var location = new Location();
    location.onLocationChanged().listen((Map<String, double> currentLoc) {
      LocationHolder.location = LatLng(currentLoc['latitude'], currentLoc['longitude']);

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('PotFolio'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              )
            ],

            bottom: TabBar(
              tabs: [
                Tab(text: "View Map"),
                Tab(text: "Submit"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MapView(),
              SubmitView(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
