import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:places/src/widgets/input_name.dart';
import 'dart:math' as Math;
void showChangeNameBottomSheet(BuildContext context,Function(String value) callback) {
  final TextEditingController controller = TextEditingController();
  showModalBottomSheet(
      context: context,
      elevation: 12,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              "Update Name",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Padding(
              padding:  EdgeInsets.only(bottom: Math.max(0,MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).size.height*.1)), //we do this so that input name wiil be visible when keyboard is on
              child: InputName(controller: controller),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                       style: ElevatedButton.styleFrom( //if we want to tweak for this particular page
                         primary: Colors.green,
                       ),
                        onPressed: () {
                          if(controller.text.trim().length<4){
                            Fluttertoast.showToast(msg: "Name must be at least 4 characters long");
                            return;
                          }
                          Navigator.of(context).pop();
                          callback(controller.text.trim());
                        },
                        child: Text("Done"),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12)
          ],
        );
      });
}