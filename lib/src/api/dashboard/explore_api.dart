
import 'dart:convert';

import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/model/network_response_model.dart';

class ExploreApi {
  Future<NetworkResponseModel> getAllPlaces() async {  //we do NetworkResponseModel so that we dont need to throw exception and use try catch in Service
    try{
      final uri = Uri.parse(AppUrl.PLACE_LIST_URL);
      final response = await baseRequest.get(uri);
      final body = jsonDecode(response.body);
   /*   List<PlaceModel> list = [];
      for(var item in body){
        PlaceModel  p = PlaceModel.fromJson(p);
        list.add(p);
      }
      return list;*/
      print("List of places $body");
      final list =   PlaceModel.allResponse(body);
      return NetworkResponseModel(status: true, data: list);
    }catch(e){
      print("The places exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception", ""));
    }
  }
}