import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/services/dashboard/explore_service.dart';
import 'package:places/src/utils/location_helper.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/viewmodels/dashboard/places_view_model.dart';
import 'package:places/src/widgets/bottomsheet/chose_image_option_bottom_sheet.dart';
import 'package:places/src/widgets/input_name.dart';
import 'package:places/src/widgets/map_input.dart';
import 'package:provider/provider.dart';

class AddNewPlaceScreen extends StatelessWidget {
  AddNewPlaceScreen({Key? key}) : super(key: key);
  final _nameController = TextEditingController();
  final _monumentController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PlacesViewModel>(
        model: PlacesViewModel(service: Provider.of(context)),
        onModelReady: _onModelReady,
        builder: (context, PlacesViewModel model, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add New Place"),
            ),
            body: _buildBody(context, model),
          );
        });
  }

  // Widget _buildChooseFromMap(BuildContext context, PlacesViewModel model) {
  //   return Container(
  //     width: MediaQuery
  //         .of(context)
  //         .size
  //         .width,
  //     margin: EdgeInsets.all(10),
  //     child: SwitchListTile.adaptive(
  //         value: true,
  //         selected: true,
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8.0),
  //             side: BorderSide()),
  //         title: Text("Select from Map"),
  //         onChanged: (val) {
  //
  //         }),
  //   );
  // }''

  Widget _buildBody(BuildContext context, PlacesViewModel model) {
    return ListView(
      children: [
        InputName(
          controller: _nameController,
          text: "Place Name",
          hint: "e.g Lalitpur",
          icon: Icons.place,
        ),
        InputName(
          controller: _monumentController,
          text: "Nearby monument ",
          hint: "e.g Dharahara",
          icon: Icons.place,
        ),
        InputName(
          controller: _descriptionController,
          text: "Place description",
          hint: "describe this place",
          icon: Icons.message,
          lines: 3,
        ),

        _buildInputImage(context, model),
        SizedBox(height: 12),
        _buildStaticImage(context, model),

        AnimatedCrossFade(
          duration: const Duration(seconds: 2),
          secondChild: _buildChooseFromMap(context, model),
          firstChild: _buildChooseFromCurrentLocation(context, model),
          crossFadeState: model.useCurrentLocation
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
        //
        SizedBox(height: 12),
        _buildSubmitButton(context, model),
      ],
    );
  }

  Widget _buildChooseFromMap(BuildContext context, PlacesViewModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all()),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Choose from map"),
          Platform.isIOS
              ? CupertinoSwitch(
              value: !model.useCurrentLocation,  //value: on/off? in model
              onChanged: (val) {
                model.setLocationMethod(true);
              })
              : Switch(
              value: !model.useCurrentLocation,
              onChanged: (val) {
                model.setLocationMethod(true);
              })
        ],
      ),
    );
  }

  Widget _buildChooseFromCurrentLocation(BuildContext context, PlacesViewModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all()),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Use current location"),
          Platform.isIOS
              ? CupertinoSwitch(
              value: model.useCurrentLocation,
              onChanged: (val) {
                model.setLocationMethod(false);
                _chooseLocationFromMap(context, model);
                // show a map
              })
              : Switch(
              value: model.useCurrentLocation,
              onChanged: (val) {
                model.setLocationMethod(false);
                _chooseLocationFromMap(context, model);

                //show from map
              })
        ],
      ),
    );
  }



  Widget _buildSubmitButton(BuildContext context, PlacesViewModel model) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: model.busy
              ? null
              : () {
            _onSubmit(context, model);
          },
          child: model.busy ? CircularProgressIndicator() : Text("Submit"),
        ),
      ),
    );
  }

  Widget _buildInputImage(BuildContext context, PlacesViewModel model) {
    // check if the image is already selected
    // if no then show a section showing no image selected
    // else show the image
    return InkWell(
      onTap: () {
        _pickImage(context, model);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: model.imagePath == null
            ? Center(
          child: Text(
            "No Image selected",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
            : Image.file(File(model.imagePath!), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildStaticImage(BuildContext context, PlacesViewModel model) {  //ony to display users. we dont save this
    // check if the image is already selected
    // if no then show a section showing no image selected
    // else show the image
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: model.location == null ? Center(
          child: Text(
            "No location chosen",
            style: Theme.of(context).textTheme.headline6,
          ),
        )
            : Image.network(LocationHelper.generateLocationPreviewImage(model.location!),
          fit: BoxFit.cover,
          // loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? progress) {
          //   if (progress == null) return child;
          //   return Center(
          //     child: CircularProgressIndicator(
          //       value: progress.expectedTotalBytes != null ?
          //       progress.cumulativeBytesLoaded / progress.expectedTotalBytes!.toInt()
          //           : null,
          //     ),
          //   );
          // },
        ),
      );

  }

  void _pickImage(BuildContext context, PlacesViewModel model) {
    showChoseImageOptionBottomSheet(context, (ImageSource source) async {
      PickedFile? pickedImage = await ImagePicker().getImage(source: source);
      if (pickedImage == null) {
        showSnackBar(context, "No image selected, please choose again");
        return;
      }
      File file = File(pickedImage.path);
      model.setImage(file.absolute.path);
    });
  }

  Future<void> _chooseLocationFromMap(
      BuildContext context, PlacesViewModel model) async {
    LatLng? chosenLocation = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) {
            return MapInput(
                onMapTapped: (loc) {}, isView:false, currentLocation: model.currentLocation);
          },
          fullscreenDialog: true),
    );
    if (chosenLocation != null) {
      model.setLocation(chosenLocation);
    }
  }

  void _onSubmit(BuildContext context, PlacesViewModel model) async {
    bool validData = validateData(context, model);
    if (!validData) return;

    List<Placemark> placeMarks = await GeocodingPlatform.instance.placemarkFromCoordinates(
        model.location!.latitude, model.location!.longitude);

    Placemark place = placeMarks.first;
    String? city = place.locality;
    String? street = place.street;
    String address = "${place.locality} + ${place.subLocality} ";
    if (city == null || street == null) {
      showSnackBar(context, "Could not fetch the address, please try again");
      return;
    }
    var response = await model.postData(
        address: address,
        city: city,
        description: _descriptionController.text,
        monument: _monumentController.text,
        name: _nameController.text,
        street: street);
    if (!response.status) {
      showSnackBar(context, response.message!);
    } else {
      showSnackBar(context, "Successfully added a new place");
      Provider.of<ExploreService>(context, listen: false).addNewPlace(response.data); //to update the explore screen after adding new place
      Navigator.of(context).pop();
    }
  }

  bool validateData(BuildContext context, PlacesViewModel model) {
    if (_nameController.text.isEmpty) {
      showSnackBar(context, "Place Name is required");
      return false;
    }
    if (_monumentController.text.isEmpty) {
      showSnackBar(context, "Monument is required");
      return false;
    }
    if (_descriptionController.text.isEmpty) {
      showSnackBar(context, "Description is required");
      return false;
    }
    if (model.imagePath == null) {
      showSnackBar(context, "Please pick a image first");
      return false;
    }
    if (model.location == null) {
      showSnackBar(context, "Please select the location.");
      return false;
    }
    return true;
  }

 void _onModelReady(PlacesViewModel model) {
    model.setInitialLocation();
  }
}
