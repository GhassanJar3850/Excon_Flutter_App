// ignore_for_file: prefer_const_constructors

import 'package:excon/components/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../constants.dart';

class Setting extends StatelessWidget {
  Setting({
    Key? key,
    required this.text,
    required this.onPressed,
    this.toggleSetting = false,
    this.toggleValue = false,
    required this.child,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final bool toggleSetting;
  final bool toggleValue;
  final Widget child;

  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.all(kPrimary),
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kCornerRoundness),
              side: BorderSide(color: Color(0xff0a0a0a),width: 0.3),
            ),
          ),
          //splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(
              ThemeService().isSavedDarkMode()
                  ? Color.fromARGB(188, 125, 125, 125)
                  : Color.fromARGB(188, 196, 196, 196)),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          children: [
            //TODO: replace the SizedBox plz
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 80,
              ),
            ),
            Expanded(
              flex: 14,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Jaldi',
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
                flex: 6,
                child: toggleSetting
                    ? FlutterSwitch(
                        activeColor: Colors.purple.shade400,
                        toggleColor: Colors.white,
                        height: 20,
                        width: 35,
                        toggleSize: 40 / 2.8,
                        value: toggleValue,
                        onToggle: (value) {
                          onPressed(value);
                        },
                      )
                    : child),
          ],
        ),
      ),
    );
  }
}
