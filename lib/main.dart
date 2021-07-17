import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/core/locator.dart';
import 'package:places/src/core/providers.dart';
import 'package:places/src/core/router.dart';
import 'package:places/src/services/navigation_service.dart';
import 'package:places/src/widgets/shared/app_colors.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: "Places",
        navigatorKey: locator<NavigationService>().navigatorKey,
        theme: ThemeData(
          primaryColor: whiteColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide.none),
            padding: EdgeInsets.all(18.0),
            primary: primaryColor,
          )
          ),

          scaffoldBackgroundColor: Colors.grey[200],

/*
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: primaryColor,
            displayColor: Colors.blue,
          ),
          // ) ,
          buttonColor: primaryColor,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: primaryColor)),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(primary: primaryColor)),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primaryColor,
          ),
          iconTheme: Theme.of(context).iconTheme.copyWith(color: primaryColor),
          primaryIconTheme:Theme.of(context).iconTheme.copyWith(color: primaryColor) ,*/

        ),
        darkTheme: ThemeData(//if dark mode
        ),
       /* home: SplashScreen(),
        routes: {
          RoutePaths.SPLASH: (_) => SplashScreen(),
        },*/
        initialRoute: RoutePaths.SPLASH,
        onGenerateRoute: Router.onGenerateRoute,  //this Router is defined by us so we need to hide in material.dart

      ),
    );
  }
}

/// route 4 ways (Priority)
///home  named argument
///if no home argument, routes named arg - searches for the map -> initial route first render, if not provided, replace it with /
///onGenerateRoute
///onUnknownRoute if no route foud