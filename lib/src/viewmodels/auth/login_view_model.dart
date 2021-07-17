
import 'package:places/src/core/base_view_model.dart';
import 'package:places/src/services/auth/auth_service.dart';

class LoginViewModel extends BaseViewModel{

/*  bool _busy = false;
  bool get busy => _busy;

  void setBusy (bool val){
    _busy = val;
    notifyListeners();
  }*/

final AuthService loginService;
LoginViewModel({required this.loginService});

String get errorMessage => loginService.errorMessage;

  Future<bool> login (String email, password) async{
    setBusy(true);
    final response = await loginService.login(email, password);
    setBusy(false);
    return response;
  }


}