import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

import 'main.dart';

class MapView extends StatefulWidget {
  State createState() => _MapViewController();
}

class _MapViewController extends State<MapView> {
  final myController = TextEditingController();
  GoogleMapController mapController;


  void _handleFABPress() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LocationHolder.location,
          zoom: 17.0,
        )
    ));
  }

  void _mapUpdatePress() {
    var data = JsonEncoder().convert({'longitude': LocationHolder.location.longitude.toString(),
      'latitude': LocationHolder.location.latitude.toString(),
      'radius': '10'});
    var url = "http://169.233.126.136/all_issues";

    http.post(url, headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: data
    ).then((response) {
      var resp = JsonDecoder().convert(response.body);

      mapController.clearMarkers();
      for (var thing in resp) {
        var sever = thing['severity'];
        var sevStr = "Something is broke";
        var hue = BitmapDescriptor.hueGreen;
        print(sever);

        if (sever <= 3) {
          hue = BitmapDescriptor.hueBlue;
          sevStr = "Fair";
        } else if (sever > 3 && sever <= 7) {
          hue = BitmapDescriptor.hueOrange;
          sevStr = "Moderate";
        } else if (sever > 7) {
          hue = BitmapDescriptor.hueRed;
          sevStr = "Severe";
        }

        mapController.addMarker(
          MarkerOptions(
            position: LatLng(thing['latitude'], thing['longitude']),
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            infoWindowText: InfoWindowText(thing['types'], sevStr)
          )
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _mapUpdatePress();
  }

  void _searchAddress(a) {

  }

  Widget build(BuildContext context) {
    LocationHolder.hasInit = true;

    return Stack(
      children: <Widget>[
        Scaffold(
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
                target: LocationHolder.location,
                zoom: LocationHolder.hasInit ? 17 : 1,
              ),
              trackCameraPosition: true,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _handleFABPress,
            child: Icon(Icons.center_focus_strong),
          ),
        ),
        Material (
          child: TextField(
            controller: myController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              hintText: "Search Address",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: _mapUpdatePress,
              child: Icon(Icons.autorenew),
            ),
          ),
        ),
    ]);
  }
}