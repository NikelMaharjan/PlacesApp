import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/services/dashboard/favorite_service.dart';
class AddFavoriteViewModel extends BaseViewModel {

  final FavoriteService service;
  AddFavoriteViewModel({required this.service});


  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;


  void addOrRemoveFromFavorite(String id) async {
    // removes from api and returns the response
    _isFavorite = !isFavorite;
    service.addOrRemoveFromFavorite(id);
    notifyListeners();
  }

  void isFavoritePlace(String id) async {
    // removes from api and returns the response
    var response = await service.isFavorite(id);
    _isFavorite = response.data as bool;
    notifyListeners();
  }


  void removeItem(PlaceModel place) async {
    List<PlaceModel> list = service.places.data!.cast<PlaceModel>();
    int index = list.indexWhere((element) => element.sId == place.sId);
    // it just removes the item from the service
    service.removeItem(index);
    notifyListeners();
    // removes from api and returns the response
    await service.removeFromApi(index, place);
    notifyListeners();
  }
}