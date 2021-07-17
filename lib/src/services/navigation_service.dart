import 'package:flutter/material.dart';
import 'package:places/src/core/constants/route_path.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> logout() {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(RoutePaths.LOGIN,
            (Route route) {
          return route.settings.name == RoutePaths.LOGIN;
        });
  }
}
