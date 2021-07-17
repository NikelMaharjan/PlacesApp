
import 'dart:convert';
import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/model/network_response_model.dart';

class FavoriteApi {
  Future<NetworkResponseModel> getAllPlaces() async {  //we do NetworkResponseModel so that we dont need to throw exception and use try catch in Service
    try{
      final uri = Uri.parse(AppUrl.FAVORITE_LIST_URL);
      final response = await baseRequest.get(uri);
      final body = jsonDecode(response.body);
      print("List of favorite $body");
      if(body["places"]==null){ //incase error
        return NetworkResponseModel(status: true, data: []);
      }
      final list =   PlaceModel.allResponse(body["places"]);  //["places"] because of api
      return NetworkResponseModel(status: true, data: list);
    }catch(e){
      print("The favorite exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception", ""));
    }
  }

  Future<NetworkResponseModel> addOrRemoveFromFavorite(String placeId) async {
    try{
      final uri = Uri.parse(AppUrl.FAVORITE_LIST_URL);
      final response = await baseRequest.put(uri,
          body: jsonEncode({"id":placeId}),
       );
      final body = jsonDecode(response.body);
      print("add or remove of favorite $body");
      if(body["places"]==null){  //in case error
        return NetworkResponseModel(status: false);
      }
      return NetworkResponseModel(status: true);
    }catch(e){
      print("The favorite add or remove exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception", ""));
    }
  }

  Future<NetworkResponseModel> isFavorite(String placeId) async {
    try {
      final uri = Uri.parse("${AppUrl.IS_FAVORITE_URL}/$placeId");
      final response = await baseRequest.get(uri);
      final body = jsonDecode(response.body);
      print("add or remove of favorite $body");
      if (body["favorite"] == null) {
        return NetworkResponseModel(status: false);
      }
      return NetworkResponseModel( status : true,data: body["favorite"] ?? false);
    } catch (e) {
      print("The favorite add or remove exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }


}