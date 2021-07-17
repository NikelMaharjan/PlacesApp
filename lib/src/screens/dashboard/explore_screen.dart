import 'package:flutter/material.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/viewmodels/dashboard/esplore_view_model.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/loading_indicator.dart';
import 'package:places/src/widgets/place_item.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ExploreViewModel>(
        model: ExploreViewModel(service: Provider.of(context)),
        onModelReady: (model) async => await model.initialize(),             //this will run before builder. so this will setBusy() true
        builder: (context, ExploreViewModel model, Widget? child) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Center(child: _buildBody(context, model)),
          );
        });
  }

  Widget _buildBody(BuildContext context, ExploreViewModel model) {
    if (model.busy) {
      return LoadingIndicator();
    }
    if (model.places.status == false) {
      return ErrorView(
          messages: model.places.message!,
          callback: () async => await model.initialize());   //there is setBusy() in initialize which have notifylisetener so builder will rerun
    }


    //we do this to update explore screen when user add new place
    return StreamBuilder(
      stream: model.placeStream,
      builder: (context, AsyncSnapshot<List<PlaceModel>> snapshot) {
        if(!snapshot.hasData){
          return   ErrorView(
              messages: "NO Data Found",
              callback: () async => await model.initialize());
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          padding: EdgeInsets.only(bottom: 12),
          itemBuilder: (BuildContext context, int index) {
            final PlaceModel place = snapshot.data![index]; // we need to do this since we define dynamic in network response model
            return InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(RoutePaths.VIEW_DETAIL, arguments: place); //router will catch this argument?
              },
              child: PlaceItem(
                  place: place,
                  location: model.currentLocation,

              ),
            );
          },
        );
      }
    );
 /*   return ListView.builder(
      itemCount: model.places.data.length,
      padding: EdgeInsets.only(bottom: 12),
      itemBuilder: (BuildContext context, int index) {
        final PlaceModel place = model.places.data[index] as PlaceModel; // we need to do this since we define dynamic in network response model
        return InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(RoutePaths.VIEW_DETAIL, arguments: place); //router will catch this argument?
          },
          child: PlaceItem(
            place: place,
            location: model.currentLocation,

          ),
        );
      },
    );*/
  }

}
