

import 'package:flutter/material.dart';

Future<T> showOverLayLoadingIndicator<T>(BuildContext context,
Future<T> future) async{  //T can be anything, bool or networkresponsemodel
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
  final response = await future;
  Navigator.of(context).pop();
  return response;
}