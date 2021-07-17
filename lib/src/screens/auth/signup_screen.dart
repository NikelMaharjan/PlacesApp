

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:places/src/core/base_view_widget.dart';
import 'package:places/src/core/constants/route_path.dart';
import 'package:places/src/utils/snackbar_helper.dart';
import 'package:places/src/viewmodels/auth/signup_view_model.dart';
import 'package:places/src/widgets/custom_app_bar.dart';
import 'package:places/src/widgets/input_email.dart';
import 'package:places/src/widgets/input_name.dart';
import 'package:places/src/widgets/input_password.dart';
import 'package:places/src/widgets/input_phone.dart';
import 'package:places/src/widgets/shared/app_colors.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();
  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController _phoneController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: blackColor87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        context: context,
        subTitle: "Create your \n account",
      ),
      body: BaseWidget<SignupViewModel>(
        model: SignupViewModel(
          loginService: Provider.of(context)
        ),
        builder: (context, SignupViewModel model, child) {
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 24),
                    InputName(
                      controller: _nameController,
                    ),
                    InputPhone(
                      controller: _phoneController,
                    ),
                    InputEmail(controller: _emailController),
                    InputPassword(controller: _passwordController),
                    _buildSubmitButton(context, model),
                    const SizedBox(height: 12),
                    _buildTermsAndConditions(context),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              _buildSignInSection(context)
            ],
          );
        }
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: primaryColor, height: 1.5),
              children: [
                TextSpan(
                    text:  'By continuing, you agree to our\n ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  style: TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                        text:  'Terms and conditions ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Terms and conditions clicked");
                          }),
                    TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Privacy policy clicked");
                          })
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, SignupViewModel model) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide.none),
            padding: EdgeInsets.all(18.0),
            primary: primaryColor,
          ),
          onPressed: model.busy? null :() {
            _onSubmit(context, model);
          },
          child: model.busy ? const CircularProgressIndicator() : const Text("Submit"),
        ),
      ),
    );
  }

  Future _onSubmit(BuildContext context, SignupViewModel model) async {

    final success = await model.signup(
       _nameController.text,_phoneController.text, _emailController.text, _passwordController.text);
    /* await Future.delayed(Duration(seconds: 3));*/
    //model.setBusy(false);
    if (success) {
      Navigator.of(context).pushReplacementNamed(RoutePaths.HOME);
    } else {
      showSnackBar(context, model.errorMessage);

    }

  }

  Widget _buildSignInSection(BuildContext context) {
    return Column(
      children: [
        Divider(),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Alreay have an account?"),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Login"),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: primaryColor)),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
