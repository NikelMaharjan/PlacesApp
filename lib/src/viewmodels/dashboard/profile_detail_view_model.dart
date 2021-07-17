

import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/dashboard/profile_detail_service.dart';

class ProfileDetailViewModel extends BaseViewModel{
  final ProfileDetailService service;
  ProfileDetailViewModel({required this.service});

  UserModel get currentUser => service.currentUser;

  Future<bool> logout() {
    return service.logout();
  }

  Future<NetworkResponseModel> updateName(String newName) async {
    var response = await service.updateName(newName);
    notifyListeners();
    return response;
  }

  Future<NetworkResponseModel> updateEmail(String newEmail) async {
    var response = await service.updateEmail(newEmail);
    notifyListeners();
    return response;
  }

  Future<NetworkResponseModel> updatePassword(String newPassword) async {
    var response = await service.updatePassword(newPassword);
    return response;
    //we dont use notifyListener since UI wont change
  }

  Future<NetworkResponseModel> updateProfilePic(String path) async {
    var response = await service.updateProfilePic(path, AppUrl.UPDATE_PROFILE_PIC_URL);
    notifyListeners();
    return response;

  }

  Future<NetworkResponseModel> updateCoverPic(String path) async {
    var response = await service.updateProfilePic(path, AppUrl.UPDATE_COVER_PIC_URL);
    notifyListeners();
    return response;
  }

}