import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/model/dashboard/my_places_view_model.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/widgets/bottomsheet/confirmation_bottom_sheet.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/favorite_item.dart';
import 'package:places/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class MyPlacesScreen extends StatelessWidget {
  const MyPlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MyPlacesViewModel>(
        model: MyPlacesViewModel(service: Provider.of(context)),
        onModelReady: (model) async => await model.initialize(),
        builder: (context, MyPlacesViewModel model, Widget? child) {
          return _buildBody(context, model);
        });
  }

  Widget _buildBody(BuildContext context, MyPlacesViewModel model) {
    if (model.busy) {
      return LoadingIndicator();
    }
    if (model.places.status == false) {
      return ErrorView(
          messages: model.places.message!,
          callback: () async => await model.initialize());
    }
    return OrientationBuilder(
        builder: (context, Orientation orientation) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ?  2 :3,
                childAspectRatio: orientation == Orientation.portrait ? MediaQuery.of(context).size.width /
                    (1190) : MediaQuery.of(context).size.width /
                    (1890),
            ),
            itemCount: model.places.data.length,
            padding: EdgeInsets.only(bottom: 12),
            itemBuilder: (BuildContext context, int index) {
              final PlaceModel place = model.places.data[index] as PlaceModel;
              return Favoriteitem(
                  place: place,
                  location: model.currentLocation,
                  onItemRemoved: (place) {
                    confirmationBottomSheet(context,(){
                      _onItemRemoved(place, model);
                    });
                  }
              );
            },
          );
        }
    );
  }

  void _onItemRemoved(PlaceModel place, MyPlacesViewModel model) {
    model.removeItem(place);
  }
}
