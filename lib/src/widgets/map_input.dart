

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInput extends StatefulWidget {
  final Function(LatLng location)? onMapTapped;
  final LatLng currentLocation;
  final bool isView;
  const MapInput({Key? key, this.isView = true, this.onMapTapped, required this.currentLocation}) : super(key: key);

  @override
  _MapInputState createState() => _MapInputState();
}

class _MapInputState extends State<MapInput> {
  late LatLng _currentLocation = widget.currentLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isView ? Text("View on Map") : Text("Choose from Map"),
        actions: [
          widget.isView ? Container():
          IconButton(onPressed: (){
            Navigator.of(context).pop(_currentLocation);
          }, icon: Icon(Icons.add_circle_outline))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 14.25
        ),
        padding: EdgeInsets.all(8),
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onTap: (LatLng location){
          setState(() {
            _currentLocation = location;
          });

        },
        markers: {
          Marker(
            markerId: MarkerId(_currentLocation.toString()),
            infoWindow: InfoWindow(title: "You are here"),
            position: _currentLocation
          )
        },
      ),
    );
  }
}



