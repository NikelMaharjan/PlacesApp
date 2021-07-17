import 'package:flutter/material.dart';
import 'package:places/src/widgets/shared/app_colors.dart';
void showLogoutBottomSheet(BuildContext context, Function callback) {
  showModalBottomSheet(
      context: context,
      elevation: 12,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                "Log out?",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 12,
              ),
              Text("Do you really want to logout? You will need to login again"),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            callback();
                          },
                          child: Text("Yes"),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 12,)
            ],
          ),
        );
      });
}