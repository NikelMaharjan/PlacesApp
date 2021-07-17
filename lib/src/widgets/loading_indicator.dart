import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Platform.isIOS
              ? CupertinoActivityIndicator(radius: 16,)
              : CircularProgressIndicator(),
          SizedBox(height: 12,),
          Text("Loading, please wait",
          style: Theme.of(context).textTheme.headline6,)
        ],
      ),
    );
  }
}
