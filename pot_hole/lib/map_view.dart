import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              )
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
        )
    ]);
  }
}