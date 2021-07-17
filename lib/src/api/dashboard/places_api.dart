import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/model/network_response_model.dart';


class PlaceApi {

  Future<NetworkResponseModel> addNewPlace({
    required String name,
    required String city,
    required String street,
    required String monument,
    required String address,
    required num latitude,
    required num longitude,
    required String description,
    required String imagePath}) async {
    try {

      final uri = Uri.parse(AppUrl.PLACES_URL);
      MultipartRequest request = MultipartRequest('POST', uri);
      request.fields.addAll({   //depends on api
        "name": name,
        "city": city,
        "street": street,
        "monument": monument,
        "address": address,
        "latitude": "$latitude",
        "longitude": "$longitude",
        "description": description,
      });


      final imageBody = await MultipartFile.fromPath("image", imagePath,
          contentType: MediaType("image", "jpg"));
      request.files.add(imageBody);
      final streamedResponse = await baseRequest.send(request);
      final response = await Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);
      print("create place response $body");
      final place = PlaceModel.fromJson(body["place"]);
      return NetworkResponseModel(status: true, data: place);
    } catch (e) {
      print("The create place  exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }
}