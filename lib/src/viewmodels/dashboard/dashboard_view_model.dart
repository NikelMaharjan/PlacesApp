

import 'package:location/location.dart';
import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/services/dashboard/dashboard_service.dart';

class DashBoardViewModel extends BaseViewModel{
  final DashBoardService service;
  DashBoardViewModel({required this.service});

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changeTab(int index){
    _currentIndex = index;
    notifyListeners();
  }

  String getAppBarTitle(){
   return ["Explore", "Favorite", "Profile"][_currentIndex];  //we wont use notifyListeners here since changeTab had already notifyListeners
    //whenever user tap, the builderFunction will rerun
  }

  void setLocation(LocationData locationData){
    service.setLocation(locationData);
  }

  Future<bool> logout() {
    return service.logout();
  }

  void updateToken(String token) {
    service.updateToken(token);
  }

}