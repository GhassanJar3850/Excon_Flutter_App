// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:excon/constants.dart';
import 'package:excon/screens/login_screen.dart';
import 'package:excon/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/gradient_button.dart';
import '../main.dart';
import 'loading_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation, backgroundAnimation;
  String name = 'EXcon';
  bool toggle = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2, milliseconds: 0),
    );

    // backgroundAnimation =
    //     ColorTween(begin: Colors.blueGrey, end: Colors.black38)
    //         .animate(controller);
    // setRotation(360);

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    Timer(Duration(seconds: 1), () {
      controller.forward();
      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse(from: 1);
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
      controller.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setRotation(double degrees) {
    double angle = degrees * pi / 180;
    animation = Tween<double>(begin: 0, end: angle).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 14,
              child: Center(
                child: Hero(
                  tag: 'logo',
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: controller.value * 15,
                        bottom: 20 - controller.value * 15),
                    child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.contain,
                      width: 1.9 * Loading.logoSize,
                      height: 1.9 * Loading.logoSize,
                      cacheHeight: 600,
                      cacheWidth: 600,
                      isAntiAlias: true,
                      //color: Color(0xF01765D9),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Hero(
                  tag: 'login_button',
                  child: GradientButton(
                    strokeWidth: 3,
                    radius: 40,
                    gradient: LinearGradient(
                        colors: [Colors.amber, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    child: Text(
                      lang.isSavedLanguage() ? 'Log in' : "تسجيل دخول",
                      style: TextStyle(
                        fontFamily: 'Jaldi',
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, LoginScreen.id);
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Hero(
                  tag: 'registration_button',
                  child: GradientButton(
                    strokeWidth: 3,
                    radius: 40,
                    gradient: LinearGradient(
                        colors: [Colors.amber, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    child:
                        Text(lang.isSavedLanguage() ? 'Register' : 'إنشاء حساب',
                            style: TextStyle(
                              fontFamily: 'Jaldi',
                              fontSize: 20,
                            )),
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(flex: 3, child: Container()),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'lang',
                    child: TextButton(
                      style: lang.isSavedLanguage()
                          ? lang_toggled
                          : lang_untoggled,
                      onPressed: () {
                        setState(() {
                          toggle = true;
                          lang.changeLang(true);
                        });
                        //TODO: Implement Language Change
                      },
                      child: Text(
                        'EN',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Jaldi',
                        ),
                      ),
                    ),
                  ),
                  Text(
                    ' | ',
                  ),
                  TextButton(
                    style:
                        lang.isSavedLanguage() ? lang_untoggled : lang_toggled,
                    onPressed: () {
                      setState(() {
                        toggle = false;
                        lang.changeLang(false);
                      });
                      //TODO: Implement Language Change
                    },
                    child: Text(
                      'AR',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Jaldi',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
