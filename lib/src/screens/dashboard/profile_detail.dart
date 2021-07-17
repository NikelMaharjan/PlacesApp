
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/model/network_response_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/utils/show_overlay_loading_indicator.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/viewmodels/dashboard/profile_detail_view_model.dart';
import 'package:places/src/widgets/bottomsheet/change_email_bottom_sheet.dart';
import 'package:places/src/widgets/bottomsheet/change_name_bottom_sheet.dart';
import 'package:places/src/widgets/bottomsheet/change_password_bottom_sheet.dart';
import 'package:places/src/widgets/bottomsheet/chose_image_option_bottom_sheet.dart';
import 'package:places/src/widgets/bottomsheet/log_out_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ProfileDetailViewModel>(
        model: ProfileDetailViewModel(service: Provider.of(context)),
        builder: (context, ProfileDetailViewModel model, snapshot) {
          return ListView(
            children: [
              _buildUserDetail(context, model),
              //-- create a enough space,
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height / 6.3),
              Divider(), _buildChangeNameSection(context, model),
              Divider(), _buildChangeEmail(context, model),
              Divider(), _buildChangePhone(context),
              Divider(), _buildChangePassword(context, model),
              Divider(), _buildLogOutSection(context, model),
              Divider(), _buildAboutUsSection(context),
              Divider(), _buildTermsAndConditionSection(context),
              Divider(), _buildPrivacyPolicySection(context),
            ],
          );
        });
  }

  Stack _buildUserDetail(BuildContext context, ProfileDetailViewModel model) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildCoverImage(context, model),
        Positioned(
          top: MediaQuery
              .of(context)
              .size
              .height / 10,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfilePicture(context, model),
              SizedBox(height: 8,),
              Text("${model.currentUser.name}", style: Theme
                  .of(context)
                  .textTheme
                  .headline6),
              SizedBox(height: 8,),
              Text("${model.currentUser.email}"),
              SizedBox(height: 8,),
              Text("${model.currentUser.phone}"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCoverImage(BuildContext context, ProfileDetailViewModel model) {
    final size = MediaQuery.of(context).size; //device size
    return InkWell(
      onTap: (){
        showChoseImageOptionBottomSheet(context, (ImageSource source){
          _chooseCoverPic(context, model, source);
        });

      },
      child: Container(
        width: size.width,
        height: size.height / 5,
        child: Image.network(
         model.currentUser.coverPic != null ? getImage(model.currentUser.coverPic!) :
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context, ProfileDetailViewModel model) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        showChoseImageOptionBottomSheet(context, (ImageSource source){
         _chooseProfilePic(context, model, source);
        });

      },
      child: Container(
        width: size.width / 4,
        height: size.width / 4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width/8),
            border: Border.all(width: 6, color: Colors.grey.shade300),
            image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(
                    model.currentUser.profilePic!= null
                        ? getImage(model.currentUser.profilePic!)
                        : "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png")
            )
        ),
      ),
    );
  }

  Widget _buildChangeNameSection(BuildContext context, ProfileDetailViewModel model) {
    return ListTile(
      title: Text("Change Name", style: Theme.of(context).textTheme.subtitle2,),
      leading: Icon(Icons.person),
      onTap: () {
        showChangeNameBottomSheet(context, (String newName) {
          _updateName(newName, context, model);
        });
      },
    );
  }

  Widget _buildChangeEmail(BuildContext context, ProfileDetailViewModel model) {
    return ListTile(
      title: Text("Change Email", style: Theme.of(context).textTheme.subtitle2,),
      leading: Icon(Icons.email),
      onTap: () {
        showChangeEmailBottomSheet(context, (String newEmail){
          _updateEmail(newEmail, context, model);
        });

      },
    );
  }

  Widget _buildChangePhone(BuildContext context) {
    return ListTile(
      title: Text("Change Phone", style: Theme
          .of(context)
          .textTheme
          .subtitle2,),
      leading: Icon(Icons.phone),
      onTap: () {},
    );
  }

  Widget _buildChangePassword(BuildContext context, ProfileDetailViewModel model) {
    return ListTile(
      title: Text("Change Password", style: Theme.of(context).textTheme.subtitle2,),
      leading: Icon(Icons.password),
      onTap: () {
        showChangePasswordBottomSheet(context, (String newPassword){
          _updatePassword(context, model, newPassword);
        });

      },
    );
  }

  Widget _buildPrivacyPolicySection(BuildContext context) {
    return ListTile(
      title: Text("Privacy Policy", style: Theme
          .of(context)
          .textTheme
          .subtitle2,),
      leading: Icon(Icons.privacy_tip_outlined),
      onTap: () {},
    );
  }

  Widget _buildTermsAndConditionSection(BuildContext context) {
    return ListTile(
      title: Text("Terms and Condition", style: Theme
          .of(context)
          .textTheme
          .subtitle2,),
      leading: Icon(Icons.document_scanner_outlined),
      onTap: () {},
    );
  }

  Widget _buildLogOutSection(BuildContext context, ProfileDetailViewModel model) {
    return ListTile(
      title: Text("Log Out",
        style: Theme.of(context).textTheme.subtitle2,),
      leading: Icon(Icons.logout),
      onTap: () async {
        showLogoutBottomSheet(context, () {
          _logout(context, model);
        });
      },
    );
  }

  Future<void> _logout(BuildContext context, ProfileDetailViewModel model) async {
  /*  showDialog(context: context, builder: (BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
    });
    final response = await model.logout();*/
    final response =  await showOverLayLoadingIndicator<bool>(context, model.logout());
    Navigator.of(context).pop();
    //if response is true then logout, else show an error message
    if (response) {
      //logout the user
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutePaths.LOGIN, (route) {
        return route.settings.name == RoutePaths.LOGIN;
      });
    }
    else {
      //show an error
      showSnackBar(context, "Could not log out now, please try again");
    }
  }

  Widget _buildAboutUsSection(BuildContext context) {
    return ListTile(
      title: Text("About US", style: Theme
          .of(context)
          .textTheme
          .subtitle2,),
      leading: Icon(Icons.info),
      onTap: () {
        showAboutDialog(
            context: context,
            applicationVersion: "1.0,1",
            applicationName: "PLaces",
            applicationLegalese: "All right reversed, XYZ Pvt. Ltd",
            applicationIcon: FlutterLogo(size: 100,)
        );
      },
    );
  }

  Future<void> _updateName(String newName, BuildContext context, ProfileDetailViewModel model) async {
  /*  showDialog(
        context: context,
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          );
        });
    final response = await model.updateName(newName);
    Navigator.of(context).pop();*/

    final response = await showOverLayLoadingIndicator<NetworkResponseModel>
      (context, model.updateName(newName));
    if (response.status) {
      showSnackBar(context, "Name updated Successfully");
    } else {
      showSnackBar(context,  response.message!);
    }
  }

  Future<void> _updateEmail(String newEmail, BuildContext context, ProfileDetailViewModel model) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          );
        });
    final response = await model.updateEmail(newEmail);
    Navigator.of(context).pop();
    if (response.status) {
      showSnackBar(context, "Email updated Successfully");
    } else {
      showSnackBar(context,  response.message!);
    }
  }

  void _updatePassword(BuildContext context, ProfileDetailViewModel model, String newPassword) async {
    final response = await showOverLayLoadingIndicator<NetworkResponseModel>
      (context, model.updatePassword(newPassword));
    if (response.status) {
      showSnackBar(context, "Password updated Successfully");
    } else {
      showSnackBar(context,  response.message!);
    }
  }

  void _chooseProfilePic(BuildContext context, ProfileDetailViewModel model, ImageSource source) async {
    PickedFile? pickedImage = await ImagePicker()
        .getImage(source: source);
    if(pickedImage == null){
      showSnackBar(context, "Could not pick image");
    }
    else{

      File file = File(pickedImage.path);
      final response = await showOverLayLoadingIndicator<NetworkResponseModel>
        (context, model.updateProfilePic(file.absolute.path));
      if(response.status){
        showSnackBar(context, "Profile picture updated successfully");
      }
      else{
        showSnackBar(context, response.message!);
      }

    }
  }
  void _chooseCoverPic (BuildContext context, ProfileDetailViewModel model, ImageSource source) async {
    PickedFile? pickedImage = await ImagePicker()
        .getImage(source: source);
    if(pickedImage == null){
      showSnackBar(context, "Could not pick image");
    }
    else{
      File file = File(pickedImage.path);
      final response = await showOverLayLoadingIndicator<NetworkResponseModel>
        (context, model.updateCoverPic(file.absolute.path));
      if(response.status){
        showSnackBar(context, "Cover picture updated successfully");
      }
      else{
        showSnackBar(context, response.message!);
      }

    }
  }
}