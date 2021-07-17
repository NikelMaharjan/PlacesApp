
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/screens/dashboard/explore_screen.dart';
import 'package:places/src/screens/dashboard/favourite_screen.dart';
import 'package:places/src/screens/dashboard/profile_screen.dart';
import 'package:places/src/utils/show_overlay_loading_indicator.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/viewmodels/dashboard/dashboard_view_model.dart';
import 'package:places/src/widgets/bottomsheet/log_out_bottom_sheet.dart';
import 'package:places/src/widgets/shared/app_colors.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {

  static const screens = [ExploreScreen(), FavoriteScreen(), ProfileScreen()];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final FirebaseMessaging _firebaseMessaging;


  @override
  Widget build(BuildContext context) {
    return BaseWidget<DashBoardViewModel>(
        model: DashBoardViewModel(service: Provider.of(context)),
        onModelReady: (model) => _onModelReady(model, context),
        builder: (context, DashBoardViewModel model, Widget? child) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: buildAppBar(model, context),
            body: _buildBody(model),
            bottomNavigationBar: _buildBottomNavigationBar(context, model),
            drawer: _buildNavigationDrawer(model, context),
          );
        });
  }

  AppBar buildAppBar(DashBoardViewModel model, context) {
    if(model.currentIndex == 2) return AppBar(toolbarHeight: 0,);   //profile page is in index 2
    return AppBar(title: Text(model.getAppBarTitle(), style: TextStyle(color: blackColor87)),
     // backgroundColor: whiteColor,
      leading: IconButton(  //no need to write this, if used default theme. will be handled by default
        icon: Icon(
          Icons.menu,
          color: Colors.black87,
        ),
        onPressed: () {
          bool drawerOpen = _scaffoldKey.currentState!.isDrawerOpen;
          if (!drawerOpen) {
            _scaffoldKey.currentState!.openDrawer();
          }
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            size: 40,
            color: blackColor87,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(RoutePaths.ADD_NEW);
          },
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }

  Widget _buildBody(DashBoardViewModel model) {
    return screens[model.currentIndex];
  }

  Widget _buildBottomNavigationBar(BuildContext context, DashBoardViewModel model) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      onTap: model.changeTab,
      currentIndex: model.currentIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedIconTheme: IconThemeData(color: Colors.black87),
      unselectedIconTheme: IconThemeData(color: Colors.grey, size: 16),
      selectedLabelStyle: TextStyle(fontSize: 18),
      unselectedLabelStyle: TextStyle(fontSize: 16),
      selectedItemColor: blackColor87,
      unselectedItemColor: blackColor54,
    );
  }

  Widget _buildNavigationDrawer(DashBoardViewModel model, context) {
    return Container(
      width: 230,
      color: whiteColor,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 120,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/16),
                child: FlutterLogo(size: 100,)),
            ListTile(
              title: Text("Explore"),
              trailing: Icon(Icons.explore),
              selected: model.currentIndex ==0,  //for design only.
              onTap: () {
                model.changeTab(0);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Favourite"),
              trailing: Icon(Icons.favorite),
              selected: model.currentIndex ==1,
              onTap: () {
                model.changeTab(1);   //this will call changeTab which has notifyListener. so all will be rebuild//repaint which is only changed
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.person),
              selected: model.currentIndex ==2,
              onTap: () {
                model.changeTab(2);
                Navigator.of(context).pop();
              },
            ),

            ListTile(
              title: Text("About us"),
              trailing: Icon(Icons.info_outline),
              selected: model.currentIndex ==3,
              onTap: () {
                showLogoutBottomSheet(context, () {
                  _logout(context, model);
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Log out"),
              trailing: Icon(Icons.exit_to_app),
              selected: model.currentIndex ==4,
              onTap: () {
               showLogoutBottomSheet(context, (){
                 _logout(context, model);
               });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context, DashBoardViewModel model) async {
    final response =  await showOverLayLoadingIndicator<bool>(context, model.logout());
    Navigator.of(context).pop();
    if (response) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutePaths.LOGIN, (route) {
        return route.settings.name == RoutePaths.LOGIN;
      });
    }
    else {
      showSnackBar(context, "Could not log out now, please try again");
    }
  }

  Future<void> _onModelReady(DashBoardViewModel model, BuildContext context) async {
    Location location =  Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;
    LocationData? _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        showSnackBar(context,"Places needs to have your location turned on to work properly");
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showSnackBar(context,"Places needs to have your permission to access location to work properly");
        return;
      }
    }
    _locationData = await location.getLocation();
    model.setLocation(_locationData);

    registerNotification(model);

  }

  void registerNotification(DashBoardViewModel model) async{

    _firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings granted  = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
    if(granted.authorizationStatus == AuthorizationStatus.authorized){
      // notification permission granted
      FirebaseMessaging.onMessage.listen((event) {
        print("notification data are ${event.data}");
       String title = event.data["title"];
       String body = event.data["body"];
       //this is where we handle notification
      });

      _firebaseMessaging.getToken().then((token) {
        if(token!= null){
          model.updateToken(token);  //for server
        }
      });

    }
    else{
      print('User declined or has not accepted permission');
    }

  }



  }


