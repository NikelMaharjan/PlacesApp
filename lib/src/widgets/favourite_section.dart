import 'package:flutter/material.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/viewmodels/dashboard/add_favourite_model.dart';
import 'package:places/src/widgets/shared/app_colors.dart';
import 'package:provider/provider.dart';
class FavoriteSection extends StatelessWidget {
  const FavoriteSection({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<AddFavoriteViewModel>(
        model: AddFavoriteViewModel(service: Provider.of(context)),
        onModelReady: (model) => model.isFavoritePlace(id),
        builder: (context, AddFavoriteViewModel model, Widget? child) {
          return IconButton(
            onPressed: () {
              model.addOrRemoveFromFavorite(id);
            },
            icon: Icon(model.isFavorite
                ? Icons.favorite_outlined
                : Icons.favorite_border),
            color: model.isFavorite ? redColor : whiteColor,
          );
        });
  }
}