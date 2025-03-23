// ignore_for_file: prefer_const_constructors

import 'package:excon/components/theme_service.dart';
import 'package:excon/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.title = "button",
    this.padding = 12,
    this.width = 120,
    required this.onPressed,
  });

  final String title;
  final double padding;
  final double width;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding,horizontal: 2),
      child: TextButton(
        style: ButtonStyle(
          //backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 27, 27, 27)),
          side: MaterialStateProperty.all(BorderSide(
            width: 2.5,
            color: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
          )),
          //elevation: MaterialStateProperty.all(50),
          fixedSize: MaterialStateProperty.all(Size.fromWidth(width)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)))),
          //minimumSize: MaterialStateProperty.all(Size(150, 40))
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Jaldi',
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
