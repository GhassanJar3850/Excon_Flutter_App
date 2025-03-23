// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:excon/main.dart';
import 'package:excon/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  static String id = 'loading_screen';
  static double logoSize = 100;

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Duration startupTime = Duration(seconds: 2, milliseconds: 500);

  @override
  void initState() {
    super.initState();
    Timer(startupTime, () {
      setState(() {
        // Navigator.pushNamed(context, WelcomeScreen.id);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(WelcomeScreen.id, (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/logo.png',
                    width: Loading.logoSize,
                    height: Loading.logoSize,
                    cacheHeight: 300,
                    cacheWidth: 300,
                    //color: Color(0xF01765D9),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "EXcon",
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: "Roboto_Slab",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              lang.isSavedLanguage() ? '                Consult an Expert' : 'استشر خبيراً',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto_Slab',
              ),
            )
          ],
        ),
      ),
    );
  }
}
