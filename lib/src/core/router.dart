

import 'package:flutter/material.dart';
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/screens/auth/login_screen.dart';
import 'package:places/src/screens/auth/signup_screen.dart';
import 'package:places/src/screens/dashboard/add_new_place_screen.dart';
import 'package:places/src/screens/dashboard/dashboard_screen.dart';
import 'package:places/src/screens/dashboard/place_detail_view.dart';
import 'package:places/src/screens/splash_screen.dart';

class Router {
 static Route<dynamic> onGenerateRoute(RouteSettings settings){

   switch(settings.name){
     case RoutePaths.SPLASH:
       return MaterialPageRoute(builder: (context)=>SplashScreen());

     case RoutePaths.LOGIN:
       return MaterialPageRoute(builder: (context)=>LoginScreen());

     case RoutePaths.REGISTER:
       return MaterialPageRoute(builder: (context)=>SignUpScreen());

     case RoutePaths.HOME:
       return MaterialPageRoute(builder: (context)=> Dashboard() );

     case RoutePaths.VIEW_DETAIL:
       final place = settings.arguments as PlaceModel;  //if multiple argument need to use List
       return MaterialPageRoute(builder: (context)=> PlaceDetailViewScreen(place: place,));


     case RoutePaths.ADD_NEW:
       return MaterialPageRoute(builder: (context)=> AddNewPlaceScreen());

     default:
       return MaterialPageRoute(builder: (context)=> Scaffold(
         body: Center(
           child: Text("No router defined for ${settings.name}"),
         ),
       ) );


   }


  }
}