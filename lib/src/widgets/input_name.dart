
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:places/src/widgets/shared/app_colors.dart';

class InputName extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String hint;
  final IconData icon;
  final lines;

  const InputName({
    Key? key,
    required this.controller,
    this.text = "Your name",   //if not passed, this will be default
    this.hint = "Nikel Maharjan",
    this.lines = 1,
    this.icon = Icons.person,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.name,
              maxLines: lines,   //1 is default
              minLines: lines,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                prefixIcon: Container(
                    width: Math.min(MediaQuery.of(context).size.width / 6, 40),
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: greyColor))),
                    child: Icon(icon),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: blackColor87, width: 1),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(4.0),
                  ),
                ),
                hintText: hint,
              ),
            ),
          ],
        ));
  }
}
