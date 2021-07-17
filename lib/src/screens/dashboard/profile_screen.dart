import 'package:flutter/material.dart';
import 'package:places/src/screens/dashboard/my_places_screen.dart';
import 'package:places/src/screens/dashboard/profile_detail.dart';

class ProfileScreen extends StatefulWidget  {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) { //we pass what need to be dismissed
          return [_buildHeader(context, innerBoxScrolled)];
        },
        body: _buildTabBarView(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool innerBoxScrolled) {
    return SliverAppBar(
      floating: true, //true will dismiss the top app bar
      pinned: true,
     // backgroundColor: Colors.white,
      forceElevated: innerBoxScrolled,
      title: Text(
        "Profile",
        style: Theme.of(context).textTheme.headline6,
      ),
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: Icon(Icons.person),
            text: "Me",
          ),
          Tab(
            icon: Icon(Icons.location_on_outlined),
            text: "My places",
          ),
          Tab(
            icon: Icon(Icons.location_on_outlined),
            text: "My places",
          ),

        ],
        physics: BouncingScrollPhysics(),
        indicatorColor: Colors.black87,
        labelColor: Colors.black87,
        labelStyle: TextStyle(color: Colors.black87),
        indicatorPadding: EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        ProfileDetail(),
        MyPlacesScreen(),
        Text("NIkel Maharjan"),
      ],
    );
  }

}
