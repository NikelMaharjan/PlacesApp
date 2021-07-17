import 'package:location/location.dart';
import 'package:places/src/api/dashboard/places_api.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';


class PlacesService {
  final PlaceApi api;
  final AuthRxProvider authRxProvider;
  PlacesService({required this.api, required this.authRxProvider});

  LocationData get currentLocation => authRxProvider.getLocation ?? LocationData.fromMap({"latitude":27.8324,"longitude":27.1232});

  Future<NetworkResponseModel> addNewPlace(
      {required String name,
        required String city,
        required String street,
        required String monument,
        required String address,
        required num latitude,
        required num longitude,
        required String description,
        required String imagePath}) {

    return api.addNewPlace(
        name: name,
        city: city,
        street: street,
        monument: monument,
        address: address,
        latitude: latitude,
        longitude: longitude,
        description: description,
        imagePath: imagePath);
  }
}