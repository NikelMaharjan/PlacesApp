import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper{

  //mapbox for static image display

  static const String mapBoxApiKey =
      "pk.eyJ1IjoiYWRoaWthcmktbWl0aHVuIiwiYSI6ImNrNGNlazEwOTBqN3YzZXBicWw3ZzdjaDcifQ.PTPsY8Dv4iXObiS4aJWlLg";
  static String generateLocationPreviewImage(LatLng latLng) {
    final url = "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${latLng.longitude},${latLng.latitude},14.25,0,60/600x600?access_token=$mapBoxApiKey";
    print("$url");
    return url;
  }

  static double calculateDistanceInKm(
      {required double latitude1,
        required double longitude1,
        required double latitude2,
        required double longitude2}) {

    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((latitude2 - latitude1) * p) / 2 +
        cos(latitude1 * p) *
            cos(latitude2 * p) *
            (1 - cos((longitude2 - longitude1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  static String getApproximateTravelTime(
      {required double latitude1,
        required double longitude1,
        required double latitude2,
        required double longitude2}) {

    double distance = calculateDistanceInKm(
        latitude1: latitude1,
        longitude1: longitude1,
        latitude2: latitude2,
        longitude2: longitude2) *
        1000;
    int minimum = (distance ~/ (60 * 20));
    if (minimum < 1) return "1 min";
    int maximum = (distance ~/ (60 * 10));
    if (minimum > 60 && maximum > 60) {
      minimum = minimum ~/ 60;
      maximum = maximum ~/ 60;
      return "$minimum-$maximum hr";
    }
    if (minimum < 60 && maximum > 60) {
      minimum = minimum ~/ 60;
      maximum = maximum ~/ 60;
      return "$minimum min-$maximum hr";
    }
    return "$minimum-$maximum min";
  }



}