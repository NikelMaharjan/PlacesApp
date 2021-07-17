import 'dart:convert';

import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_url.dart';
import 'package:places/src/model/user_model.dart';

class AuthApi {   //return type String based on api
  Future<String> login(String email, String password) async {  //use NetworkResponeModel here also
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    try {
      var uri = Uri.parse(AppUrl.LOGIN_URL);
      final response = await baseRequest.post(
        uri,
        body: jsonEncode(requestBody),
      );
      final body = response.body;
      print("login response $body");
      final parsed = jsonDecode(body);
      if(parsed["token"]==null){
        throw Exception(
            parsed["error"]?? "Could not login with credential provided");
      }
      return parsed["token"];
    } catch (e) {   //socket/network exception?  //this is catched by loginService
      print("login exception $e");
      throw Exception("$e");
    }
  }

  Future<UserModel> fetchUserDetail() async {
    try {
      var uri = Uri.parse(AppUrl.PROFILE_URL);
      final response = await baseRequest.get(
        uri,
      );
      final body = response.body;
      print("me response $body");
      final parsed = jsonDecode(body);
      if (parsed["data"] == null) {
        throw Exception(
            parsed["error"] ?? "Could not get your profile detail");
      }
      return UserModel.fromJson(parsed["data"]);
    } catch (e) {
      print("profile fetch exception $e");
      throw Exception("$e");
    }
  }

  Future<String> register(
      String name, String phone, String email, String password) async {
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
    };
    try {
      var uri = Uri.parse(AppUrl.REGISTER_URL);
      final response = await baseRequest.post(
        uri,
        body: jsonEncode(requestBody),
      );
      final body = response.body;
      print("Signup response $body");
      final parsed = jsonDecode(body);
      if (parsed["token"] == null) {
        throw Exception(
            parsed["error"] ?? "Could not Register with the credential provided");
      }
      return parsed["token"];
    } catch (e) {
      print("Sigup exception $e");
      throw Exception("$e");
    }
  }
}
