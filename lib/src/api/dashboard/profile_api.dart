import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/model/user_model.dart';

class ProfileApi {
  Future<NetworkResponseModel> updateName(String name) async {
    try {
      final uri = Uri.parse(AppUrl.UPDATE_NAME_URL);
      final response = await baseRequest.put(
        uri,
        body: jsonEncode({"name": name}),
      );
      final body = jsonDecode(response.body);
      print("update name response $body");
      final user = UserModel.fromJson(body["data"]);
      return NetworkResponseModel(status: true, data: user);
    } catch (e) {
      print("The update name  exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }

  Future<NetworkResponseModel> updatePassword(String password) async {
    try {
      final uri = Uri.parse(AppUrl.UPDATE_PASSWORD_URL);
      final response = await baseRequest.put(
        uri,
        body: jsonEncode({"password": password}),
      );
      final body = jsonDecode(response.body);
      print("update password response $body");
      if (body["token"] == null) {
        return NetworkResponseModel(status: false, data: body["error"]);
      }
      final data = body["token"];
      return NetworkResponseModel(status: true, data: data);
    } catch (e) {
      print("The update password  exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }

  Future<NetworkResponseModel> updateEmail(String email) async {
    try {
      final uri = Uri.parse(AppUrl.UPDATE_EMAIL_URL);
      final response = await baseRequest.put(
        uri,
        body: jsonEncode({"email": email}),
      );
      final body = jsonDecode(response.body);
      print("update email response $body");
      final user = UserModel.fromJson(body["data"]);
      return NetworkResponseModel(status: true, data: user);
    } catch (e) {
      print("The update email  exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }

  Future<NetworkResponseModel> updateProfilePic(String imagePath, String url) async {
    try {
      final uri = Uri.parse(url);
      MultipartRequest request = MultipartRequest('PUT', uri);
    /*  request.fields.addAll({
        "name": "Bishnu Bhusal",
        "age": "33",
        "address": "Temp Address",
      });*/

      final imageBody = await MultipartFile.fromPath("image", imagePath,   //image comes from api (can be other, depends on api)
          contentType: MediaType("image", "jpg"));
      request.files.add(imageBody);
      final streamedResponse = await baseRequest.send(request);
      final response = await Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);
      print("update image response $body");
      final user = UserModel.fromJson(body["data"]);
      return NetworkResponseModel(status: true, data: user);
    } catch (e) {
      print("The update profile pic  exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }

  Future<NetworkResponseModel> updateToken(String token) async {
    try {
      final uri = Uri.parse(AppUrl.UPDATE_TOKEN_URL);
      final response = await baseRequest.put(
        uri,
        body: jsonEncode({"token": token}),
      );
      final body = jsonDecode(response.body);
      print("update token response $body");
      final user = UserModel.fromJson(body["data"]);
      return NetworkResponseModel(status: true, data: user);
    } catch (e) {
      print("The update token  exception $e");
      return NetworkResponseModel(
          status: false, message: "$e".replaceAll("Exception:", ""));
    }
  }
}
