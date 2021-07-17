import 'package:places/src/core/base_request.dart';
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/model/user_model.dart';
import 'package:places/src/services/auth_rx_provider.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';

class SplashService {
  final CacheProvider cacheProvider;
  final DbProvider dbProvider;
  final AuthRxProvider authRxProvider;

  SplashService(
      {required this.cacheProvider,
      required this.dbProvider,
      required this.authRxProvider});


  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> initialize() async {
    UserModel? user = await dbProvider.getUser();
    if (user == null) {
      /// the user has not logged in yet
      return;
    }

    //we can avoid this step
    String? token = await cacheProvider.getStringValue(TOKEN_KEY);
    if (token == null) {
      /// the user has not logged in yet
      return;
    }
    baseRequest.setDefaultHeaders({"x-auth-token":token});  //this token will pass throughout the BaseRequest
    authRxProvider.addToken(token);
    authRxProvider.addUser(user);
    _isLoggedIn = true;
  }
}
