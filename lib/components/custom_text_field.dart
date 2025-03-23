// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:excon/components/theme_service.dart';
import 'package:excon/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // TODO: configure the rest of the attributes
  const CustomTextField({
    this.obscureText = false,
    required this.hintText,
    this.hintTextColor = Colors.black,
    required this.onChanged,
    required this.onSubmitted,
    this.inputType = TextInputType.text,
    this.prefixIcon = Icons.info,
  });

  final TextInputType inputType;
  final bool obscureText;
  final String hintText;
  final Color hintTextColor;
  final Function onChanged;
  final Function onSubmitted;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    bool obscureText1 = obscureText;
    return SizedBox(
      height: 50,
      child: TextField(
        enableInteractiveSelection: true,
        keyboardType: inputType,
        obscureText: obscureText1,
        onChanged: (value) {
          onChanged(value);
        },
        onSubmitted: (value) {
          onSubmitted;
        },
        style: TextStyle(fontFamily: 'Jaldi', fontSize: 18),
        textAlign: TextAlign.center,
        autocorrect: true,
        cursorWidth: 3,
        cursorRadius: Radius.circular(10),
        cursorColor: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
        decoration: InputDecoration(
          // The rest is configured in theme_service.dart
          hintText: hintText,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          prefixIcon: prefixIcon != Icons.info ? Icon(prefixIcon) : null,
          // suffix: hintText == 'Password'
          //     ? IconButton(
          //         onPressed: () {},
          //
          //         icon: Icon(obscureText1
          //             ? Icons.remove_red_eye
          //             : Icons.remove_red_eye_outlined),
          //         iconSize: 10,
          //       )
          //     : null,
        ),
      ),
    );
  }
}
