import 'package:location/location.dart';
import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/services/dashboard/my_place_service.dart';

class MyPlacesViewModel extends BaseViewModel {

  final MyPlacesService service;

  MyPlacesViewModel({required this.service});

  LocationData? get currentLocation => service.currentLocation;

  NetworkResponseModel get places => service.places;

  Future<void> initialize() async {
    setBusy(true);
    await service.getAllPlaces();
    setBusy(false);
  }

  void removeItem(PlaceModel place) async{
    List<PlaceModel> list =  service.places.data!.cast<PlaceModel>();
    int index = list.indexWhere((element) => element.sId == place.sId);
    // it just removes the item from the service
    service.removeItem(index);
    notifyListeners();
    // removes from api and returns the response
    await service.reemoveFromApi(index,place);
    notifyListeners();
  }
}
