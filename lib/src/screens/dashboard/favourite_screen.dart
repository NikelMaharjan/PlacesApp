import 'package:flutter/material.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/viewmodels/dashboard/favourite_view_model.dart';
import 'package:places/src/widgets/error_view.dart';
import 'package:places/src/widgets/favorite_item.dart';
import 'package:places/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseWidget<FavoriteViewModel>(
        model: FavoriteViewModel(service: Provider.of(context)),
        onModelReady: (model) async => await model.initialize(),
        builder: (context, FavoriteViewModel model, Widget? child) {
          return Container(
            padding: EdgeInsets.all(16),
            child: _buildBody(context, model),
          );
        });
  }
  Widget _buildBody(BuildContext context, FavoriteViewModel model) {
    if (model.busy) {
      return LoadingIndicator();
    }
    if (model.places.status == false) {
      return ErrorView(
          messages: model.places.message!,
          callback: () async => await model.initialize());
    }
    return ListView.builder(
      itemCount: model.places.data.length,
      padding: EdgeInsets.only(bottom: 12),
      itemBuilder: (BuildContext context, int index) {
        final PlaceModel place = model.places.data[index] as PlaceModel;
        return Favoriteitem(place: place,
            location: model.currentLocation,
          onItemRemoved: (place) =>_onItemRemoved(place, model),
        );
      },
    );
  }

  void _onItemRemoved(PlaceModel place, FavoriteViewModel model) {
    model.removeItem(place);
  }
}
