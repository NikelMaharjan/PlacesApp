import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/utils/location_helper.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({Key? key, required this.place, this.location})
      : super(key: key);
  final PlaceModel place;
  final LocationData? location;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                child: Image.network(getImage(place.image!)),
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(height: 8),
              Text("${place.name}",
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 8),
              Text("Near: ${place.monument}"),
              const SizedBox(height: 8),
              location == null
                  ? const Text("Some distance away")
                  : Text(
                  "${LocationHelper.calculateDistanceInKm(latitude1: location!.latitude!, longitude1: location!.longitude!, latitude2: place.latitude!, longitude2: place.longitude!).toStringAsFixed(1)} KM"),
              const SizedBox(height: 8),
              location == null
                  ? const Text("Few moments away")
                  : Text(
                  "${LocationHelper.getApproximateTravelTime(latitude1: location!.latitude!, longitude1: location!.longitude!, latitude2: place.latitude!, longitude2: place.longitude!)}"),
              const SizedBox(height: 8),
              Text("${place.description}"),
            ],
          ),
        ),
      ),
    );
  }
}
