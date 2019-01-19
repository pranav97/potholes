import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  State createState() => _MapViewController();
}

class _MapViewController extends State<MapView> {
  GoogleMapController mapController;
  var currentLocation = LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();

    var location = new Location();
    location.onLocationChanged().listen((Map<String, double> currentLoc) {
      currentLocation = LatLng(currentLoc['latitude'], currentLoc['longitude']);
    });
  }

  void _handleFABPress() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 18.0,
        )
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        options: GoogleMapOptions(
            cameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 1.0,
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleFABPress,
        child: Icon(Icons.center_focus_strong),
      ),
    );
  }
}