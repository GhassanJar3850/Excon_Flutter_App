// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:excon/connection/db.dart';
import 'package:excon/constants.dart';
import 'package:excon/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/custom_text_field.dart';
import '../components/gradient_button.dart';
import '../connection/Routes.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late String email = "";
  late String password = "";
  late Routes expert = Routes();
  late CurrentUser cUserCtr = Get.put(CurrentUser());
  late AnimationController controller = AnimationController(vsync: this);
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2, milliseconds: 0),
    );
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

  var welcomeText = "Welcome back !";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      padding: EdgeInsets.only(
                          top: controller.value * 15,
                          bottom: 15 - controller.value * 15),
                      height: 220,
                      width: 220,
                      child: Image.asset(
                        'images/logo.png',
                        width: 1.9 * 100,
                        height: 1.9 * 100,
                        cacheHeight: 600,
                        cacheWidth: 600,
                        isAntiAlias: true,
                        //color: Color(0xF01765D9),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 12,
                  ),
                  CustomTextField(
                    prefixIcon: Icons.alternate_email_rounded,
                    hintText: lang.isSavedLanguage() ? 'Email' : 'البريد الإلكتروني',
                    inputType: TextInputType.emailAddress,
                    hintTextColor: Colors.grey,
                    onChanged: (value) {
                      email = value;
                    },
                    onSubmitted: () {},
                  ),
                  SizedBox(
                    height: screenHeight / 60,
                  ),
                  CustomTextField(
                    prefixIcon: Icons.key_rounded,
                    obscureText: true,
                    hintText: lang.isSavedLanguage() ? 'Password' : 'كلمة المرور',
                    inputType: TextInputType.visiblePassword,
                    hintTextColor: Colors.grey,
                    onChanged: (value) {
                      password = value;
                    },
                    onSubmitted: () {},
                  ),
                  SizedBox(
                    height: screenHeight / 18,
                  ),
                  Hero(
                    tag: 'login_button',
                    child: SizedBox(
                      height: 60,
                      child: GradientButton(
                        strokeWidth: 3,
                        radius: 40,
                        gradient: LinearGradient(
                            colors: [Colors.amber, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        child:
                        Text(lang.isSavedLanguage() ? 'Log in' : 'تسجيل الدخول',
                            style: TextStyle(
                              fontFamily: 'Jaldi',
                              fontSize: 20,
                            )),
                        onPressed: () async {
                          if (email.length > 3 && password.length > 3) {
                            List<dynamic> response =
                            json.decode(await expert.logIn(email, password));
                            var nestedExpertJson = response[0]['expert'];
                            var nestedUserJson = response[0]['user'];

                            setState(() {
                              if (response[0]['success'] == false) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.redAccent,
                                        size: 40,
                                      ),
                                      content: Text(
                                        lang.isSavedLanguage()
                                            ? "Invalid email or password"
                                            : "خطأ في كلمة المرور أو البريد الإلكتروني",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                lang.isSavedLanguage()
                                                    ? 'Ok'
                                                    : "حسناً",
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontFamily: 'Jaldi',
                                                    fontSize: 16),
                                              )),
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else {
                                var nestedExpertJson = response[0]['expert'];
                                var nestedUserJson = response[0]['user'];
                                current_id = nestedUserJson['id'];
                                current_is_expert = nestedUserJson['is_expert'];
                                current_balance = nestedUserJson['balance'];

                                var nestedConsultTypes = response[0]['consultations'];
                                var engConsultTypes = [];

                                for (int j = 0; j < nestedConsultTypes.length; j++) {
                                  engConsultTypes.add(
                                      nestedConsultTypes[j]['type_en'] != null
                                          ? true
                                          : false);
                                  print(engConsultTypes);
                                }

                                current_consultTypes =
                                    ConsultationsToText(engConsultTypes);

                                // Load Credentials
                                if (current_is_expert == 1) {
                                  cUserCtr.loadExpertCredentials(
                                    nestedUserJson['name'],
                                    nestedUserJson['email'],
                                    nestedUserJson['phone'],
                                    nestedUserJson['balance'],
                                    nestedExpertJson['bio'],
                                    nestedExpertJson['address'],
                                    nestedUserJson['id'],
                                    nestedUserJson['is_expert'],
                                    response[0]['consultations'],
                                  );
                                } else {
                                  cUserCtr.loadUserCredentials(
                                    nestedUserJson['name'],
                                    nestedUserJson['email'],
                                    nestedUserJson['phone'],
                                    nestedUserJson['balance'],
                                    nestedUserJson['id'],
                                  );
                                }
                                print(current_id);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    HomeScreen.id, (route) => false);
                              }
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Icon(
                                    Icons.info_outline,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                  content: Text(
                                    lang.isSavedLanguage()
                                        ? "Enter a valid email and password"
                                        : "ادخل بريد إلكتروني و كلمة مرور صالحة",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          lang.isSavedLanguage() ? 'Ok' : "حسناً",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontFamily: 'Jaldi',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
* Hero(
              tag: 'logo',
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  'images/logo.png',
                  width: 1 * 100,
                  height: 1 * 100,
                  cacheHeight: 1000,
                  cacheWidth: 1000,
                  //color: Color(0xF01765D9),
                ),
              ),
            ),
            SizedBox(
              height: 80.0,
            ),
            CustomTextField(
              hintText: 'Email',
              inputType: TextInputType.emailAddress,
              hintTextColor: Colors.grey,
              onChanged: (value) {
                email = value;
              },
              onSubmitted: () {},
            ),
            SizedBox(
              height: 12.0,
            ),
            CustomTextField(
              obscureText: true,
              hintText: 'Password',
              inputType: TextInputType.visiblePassword,
              hintTextColor: Colors.grey,
              onChanged: (value) {
                password = value;
              },
              onSubmitted: () {},
            ),
            SizedBox(
              height: 64.0,
            ),
            Hero(
              tag: 'login_button',
              child: GradientButton(
                strokeWidth: 3,
                radius: 40,
                gradient: LinearGradient(
                    colors: [Colors.amber, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                child: Text('Log in',
                    style: TextStyle(
                      fontFamily: 'Jaldi',
                      fontSize: 20,
                    )),
                onPressed: () async{
                  var response=jsonDecode(await expert.logIn(email, password));
                  setState(() {
                    if (response['status'] == "error") {
                      print('not found');
                    } else {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(HomeScreen.id, (route) => false);
                    }
                    // Navigator.pushNamed(context, HomeScreen.id);
                  });
                },
              ),
            ),*/
