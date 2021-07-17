import 'package:flutter/material.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/viewmodels/splash_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<SplashViewModel>(
      model: SplashViewModel(
        service: Provider.of(context)
      ),
      onModelReady: (model) => _onModelReady(model, context), //this will be called before builder since we defined onModelReady in initstate in basewidget
      builder: (context, SplashViewModel model, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/capture.png"
                ),
              )
            ),
          ),


        );
      }
    );
  }

  Future<void >_onModelReady(SplashViewModel model, BuildContext context) async {
    await model.initialize();
    bool isLoggedIn = model.isLoggedIn;

    String? screen;
    await Future.delayed(Duration(seconds: 2));
    if(isLoggedIn){
      screen = RoutePaths.HOME;
    }
    else{
      screen = RoutePaths.LOGIN;
    }

Navigator.of(context).pushReplacementNamed(screen);  //pushreplacemet will replace/clear. push will put into stack. so we can do back with push

    //navigate to login screen if isLoggedIn == false elese to DashboardScreen
  }
}
