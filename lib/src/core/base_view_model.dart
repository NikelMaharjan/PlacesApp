import 'package:flutter/material.dart';




//we create this different class instead using in loginViewModel since this portion will be used in many pages. login/signup
class BaseViewModel extends ChangeNotifier
{
  bool _busy = false;
  bool get busy => _busy;

  void setBusy (bool val){
    _busy = val;
    notifyListeners();
  }
}