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
    var data = JsonEncoder().convert({'latitude': LocationHolder.location.longitude.toString(),
      'longitude': LocationHolder.location.latitude.toString(),
      'radius': '10'});
    var url = "http://169.233.126.136/all_issues";
    http.post(url, headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: data
    ).then((response) {
      var resp = JsonDecoder().convert(response.body);
      for (var thing in resp) {
        mapController.addMarker(
          MarkerOptions(
            position: LatLng(thing['longitude'], thing['latitude']),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          )
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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