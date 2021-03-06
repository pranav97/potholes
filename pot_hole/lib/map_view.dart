import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:core';

import 'main.dart';

class MapView extends StatefulWidget {
  State createState() => _MapViewController();
}

class _MapViewController extends State<MapView> {
  GoogleMapController mapController;
  var mapsStyle = '[{"featureType":"administrative","elementType":"geometry","stylers":[{"visibility":"off"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]}]';

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
    var url = "http://potfolio.appspot.com/all_issues";

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
    var url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?";
    url += "key=AIzaSyCUfMjcchqJUvvpPDDw675k5D37fvyIoyo&";
    url += "inputtype=textquery&";
    url += "fields=geometry&";
    url += "input=" + Uri.encodeFull(a);

    http.get(url).then((response) {
      var obj = JsonDecoder().convert(response.body);
      if (obj['status'] != 'OK') {
        var specMsg = (obj['status'] == 'ZERO_RESULTS') ? "No results found" : "A general error occurred";
        showDialog(
          context: context,
          builder: (buildContext) {
            return AlertDialog(
              title: new Text("Error"),
              content: new Text(specMsg),
            );
          }
        );
      } else {
        print(obj["candidates"][0]["geometry"]["location"]["lng"]);
        print(obj["candidates"][0]["geometry"]["location"]["lng"]);
        var loc = LatLng(obj["candidates"][0]["geometry"]["location"]["lat"],
            obj["candidates"][0]["geometry"]["location"]["lng"]);
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom:17)
        ));
      }
    });
  }

  Widget build(BuildContext context) {
    LocationHolder.hasInit = true;

    return Stack(
      children: <Widget>[
        Scaffold(
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              compassEnabled: false,
              cameraPosition: CameraPosition(
                target: LocationHolder.location,
                zoom: LocationHolder.hasInit ? 17 : 1,
              ),
              trackCameraPosition: true,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "thisIsAlsoUnique",
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
            textInputAction: TextInputAction.go,
            onSubmitted: _searchAddress,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              heroTag: "thisIsUnique",
              onPressed: _mapUpdatePress,
              child: Icon(Icons.autorenew),
            ),
          ),
        ),
    ]);
  }
}