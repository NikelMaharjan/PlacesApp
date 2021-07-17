



import 'package:places/src/api/auth_api.dart';
import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';

//service communicate between viewModel and api, db..... so bridge

class AuthService{

  final AuthApi api;
  final DbProvider dbProvider;
  final CacheProvider cacheProvider;
  final AuthRxProvider authRxProvider;
  AuthService({required this.api, required this.dbProvider, required this.authRxProvider, required this.cacheProvider});  //dependency injection

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future <bool> login(String email, String password) async{
    try {
      String token = await api.login(email, password);
      //fetch user profile, save in pur local database, save in local cache
      baseRequest.setDefaultHeaders({"x-auth-token" : token});
      return fetchUserDetail(token);
    }
    catch(e){
      //throw Exception("$e");   //this will catch all exception of api and others
      _errorMessage = "$e".replaceAll("Exception:", "");   //we are not using throw or other since multiple exception will be displayed of both auth api and this
      return false;
    }

  }

  Future <bool> signup(String name, String phone, String email, String password) async{
    try {
      String token = await api.register(name, phone, email, password);
      baseRequest.setDefaultHeaders({"x-auth-token" : token});
      //fetch user profile, save in pur local database, save in local cache
      return fetchUserDetail(token);
    }
    catch(e){
      _errorMessage = "$e".replaceAll("Exception:", "");
      return false;
    }

  }

  Future<bool> fetchUserDetail(String token) async{
    try {
       UserModel user =  await api.fetchUserDetail();
       //store the user in db
       //store token in cache
       await dbProvider.insertUser(user);
       await cacheProvider.setStringValue(TOKEN_KEY, token);
       authRxProvider.addUser(user);
       authRxProvider.addToken(token);
     return true;


    }
    catch(e){
      //throw Exception("$e");   //this will catch all exception of api and others
      _errorMessage = "$e".replaceAll("Exception:", "");   //we are not using throw or other since multiple exception will be displayed of both auth api and this
      return false;
    }
  }
}