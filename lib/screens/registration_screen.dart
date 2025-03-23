// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../components/custom_text_field.dart';
import '../components/gradient_button.dart';
import '../components/theme_service.dart';
import '../connection/Routes.dart';
import '../connection/db.dart';
import '../constants.dart';
import '../main.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

var uploadImage = XFile("images/profile2.png");

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  var location = "";
  var password = "";
  var name = "";
  var email = "";
  var phone = "";
  var bio = "";
  var serviceCost = 0;
  late Routes expert = Routes();
  List<bool> consultTypes = List.generate(4, (_) => false);

  /*

  * 1 => tech
  * 2 => vocational
  * 3 => legal
  * 4 => medical
  *
  * */

  late CurrentUser cUserCtr = Get.put(CurrentUser());
  late TabController registrationTabController;
  late AnimationController controller = AnimationController(vsync: this);
  String userText = lang.isSavedLanguage()
      ? 'Benefit From The Expertise Of Others  .  .  . '
      : 'استفد من خبرات الآخرين . . .';

  //TODO: (optional) add more quotes

  var pressed = false;

  // Future<void> chooseImage() async {
  //   var chosenImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   //set source: ImageSource.camera to get image from camera
  //   setState(() {
  //     uploadImage = chosenImage!;
  //     imagePath = chosenImage.path;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    registrationTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    Timer(Duration(seconds: 1), () {
      controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3, milliseconds: 0),
      );
      controller.forward();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        'images/logo.png',
                        width: 0.7 * 100,
                        height: 0.7 * 100,
                        cacheHeight: 1000,
                        cacheWidth: 1000,
                        isAntiAlias: true,
                        // 2
                        // color: Color(0xF01765D9),
                      ),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(kCornerRoundness),
                    elevation: 5,
                    child: Container(
                      width: 180,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ThemeService().isSavedDarkMode()
                            ? kPrimary
                            : kSecondary,
                        borderRadius: BorderRadius.circular(kCornerRoundness),
                      ),
                      child: TabBar(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 3,
                          automaticIndicatorColorAdjustment: true,
                          indicatorColor: ThemeService().isSavedDarkMode()
                              ? kSecondary
                              : kPrimary,
                          controller: registrationTabController,
                          tabs: [
                            Tab(
                              child: Text(
                                lang.isSavedLanguage() ? 'User' : 'مستخدم',
                                style: TextStyle(
                                    color: ThemeService().isSavedDarkMode()
                                        ? kSecondary
                                        : kPrimary,
                                    fontSize: 18),
                              ),
                            ),
                            Tab(
                              child: Text(
                                lang.isSavedLanguage() ? 'Expert' : 'خبير',
                                style: TextStyle(
                                    color: ThemeService().isSavedDarkMode()
                                        ? kSecondary
                                        : kPrimary,
                                    fontSize: 18),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Container(
                    width: 45,
                  ),
                ],
              ),
            ),

            // Tabs
            Expanded(
              flex: 14,
              child: TabBarView(
                controller: registrationTabController,
                children: [
                  // User Registration
                  Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          child: Text(
                            ((controller.value * userText.length).toInt() ==
                                    userText.length)
                                ? userText
                                : "${userText.substring(0, (controller.value * userText.length).toInt())}_",
                            style: TextStyle(fontSize: 29),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.person,
                          hintText: lang.isSavedLanguage() ? 'Name' : 'الاسم',
                          inputType: TextInputType.name,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            name = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.phone,
                          hintText: lang.isSavedLanguage() ? 'Phone' : 'الهاتف',
                          inputType: TextInputType.phone,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            phone = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.alternate_email_rounded,
                          hintText: lang.isSavedLanguage()
                              ? 'Email'
                              : "البريد الإلكتروني",
                          inputType: TextInputType.emailAddress,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            email = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.key_rounded,
                          obscureText: true,
                          hintText: lang.isSavedLanguage()
                              ? 'Password'
                              : "كلمة المرور",
                          inputType: TextInputType.visiblePassword,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            password = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),
                    ],
                  ),

                  // Expert Registration
                  Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: ToggleButtons(
                            constraints:
                                BoxConstraints(minWidth: 76, minHeight: 45),
                            selectedColor: Colors.amber,
                            fillColor: Color.fromARGB(70, 198, 26, 255),
                            borderRadius: BorderRadius.circular(20),
                            isSelected: consultTypes,
                            onPressed: (int index) {
                              setState(() {
                                consultTypes[index] = !consultTypes[index];
                              });
                            },
                            children: const [
                              Icon(
                                Icons.laptop,
                                size: 25,
                              ),
                              Icon(
                                Icons.medical_services_outlined,
                                size: 25,
                              ),
                              Icon(
                                Icons.account_balance,
                                size: 25,
                              ),
                              Icon(
                                Icons.work_outline,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            //Profile Pic
                            Expanded(
                              flex: 10,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: GestureDetector(
                                      onTap: () async {
                                        uploadImage = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery) ??
                                            XFile("images/profile2.png");
                                        print(uploadImage.path);
                                        setState(() {
                                          if (uploadImage.path !=
                                              "images/profile2.png") {
                                            pressed = true;
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: const [
                                                  Colors.amber,
                                                  Colors.purple
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: pressed
                                              ? Image.file(
                                                  File(uploadImage.path),
                                                  cacheHeight: 400,
                                                  cacheWidth: 400,
                                                  fit: BoxFit.fitWidth,
                                                )
                                              : Image.asset(
                                                  'images/profile2.png',
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 1, child: Container())
                                ],
                              ),
                            ),

                            Expanded(flex: 1, child: Container()),

                            //Name & Phone
                            Expanded(
                              flex: 16,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomTextField(
                                      prefixIcon: Icons.person,
                                      hintText: lang.isSavedLanguage()
                                          ? 'Name'
                                          : "الاسم",
                                      inputType: TextInputType.name,
                                      hintTextColor: Colors.grey,
                                      onChanged: (value) {
                                        name = value;
                                      },
                                      onSubmitted: () {},
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomTextField(
                                      prefixIcon: Icons.phone,
                                      hintText: lang.isSavedLanguage()
                                          ? 'Phone'
                                          : "الهاتف",
                                      inputType: TextInputType.phone,
                                      hintTextColor: Colors.grey,
                                      onChanged: (value) {
                                        phone = value;
                                      },
                                      onSubmitted: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Location & Service Cost
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: CustomTextField(
                                prefixIcon: Icons.monetization_on_outlined,
                                hintText: lang.isSavedLanguage()
                                    ? 'Serv.Cost'
                                    : "سعر الخدمة",
                                inputType: TextInputType.number,
                                hintTextColor: Colors.grey,
                                onChanged: (value) {
                                  serviceCost = int.parse(value.toString());
                                },
                                onSubmitted: () {},
                              ),
                            ),
                            Expanded(child: Container()),
                            Expanded(
                              flex: 10,
                              child: CustomTextField(
                                prefixIcon: Icons.location_on_rounded,
                                hintText: lang.isSavedLanguage()
                                    ? 'Location'
                                    : "العنوان",
                                inputType: TextInputType.streetAddress,
                                hintTextColor: Colors.grey,
                                onChanged: (value) {
                                  location = value;
                                },
                                onSubmitted: () {},
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.list,
                          hintText: lang.isSavedLanguage() ? 'Bio' : "الوصف",
                          inputType: TextInputType.text,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            bio = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),

                      // Email & Password
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.alternate_email_rounded,
                          hintText: lang.isSavedLanguage()
                              ? 'Email'
                              : "البريد الإلكتروني",
                          inputType: TextInputType.emailAddress,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            email = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          prefixIcon: Icons.key_rounded,
                          obscureText: true,
                          hintText: lang.isSavedLanguage()
                              ? 'Password'
                              : "كلمة المرور",
                          inputType: TextInputType.visiblePassword,
                          hintTextColor: Colors.grey,
                          onChanged: (value) {
                            password = value;
                          },
                          onSubmitted: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),

            Expanded(
              flex: 2,
              child: Hero(
                tag: 'registration_button',
                child: GradientButton(
                  strokeWidth: 3,
                  radius: 40,
                  gradient: LinearGradient(
                      colors: const [Colors.amber, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  child: Text(
                    lang.isSavedLanguage() ? 'Register' : "إنشاء حساب",
                    style: TextStyle(
                      fontFamily: 'Jaldi',
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await expert.pushUser(name, email, password, phone,
                          serviceCost, location, bio, consultTypes);

                      Future.delayed(Duration(seconds: 1));

                      List<dynamic> response =
                          json.decode(await expert.logIn(email, password));
                      var nestedJson = response[0]['user'];


                      if (!response[0]['success']) {
                        print('404 NOT FOUND');
                      } else {
                        setState(() {
                          print("name : ${nestedJson['name']}");
                          print("email : ${nestedJson['email']}");
                          print("phone : ${nestedJson['phone']}");
                          current_id = nestedJson['id'];
                          current_is_expert = nestedJson['is_expert'];
                          current_balance = nestedJson['balance'];

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
                          print(consultTypes);
                          if (current_is_expert == 1) {
                            cUserCtr.loadExpertCredentials(
                                nestedJson['name'],
                                nestedJson['email'],
                                nestedJson['phone'],
                                nestedJson['balance'],
                                bio,
                                location,
                                nestedJson['id'],
                                nestedJson['is_expert'],
                                current_consultTypes);
                          } else {
                            cUserCtr.loadUserCredentials(
                                nestedJson['name'],
                                nestedJson['email'],
                                nestedJson['phone'],
                                nestedJson['balance'],
                                nestedJson['id']);
                          }
                        });
                        if (location != "" && serviceCost != 0 && bio != "") {
                          await expert.uploadImage(
                              File(uploadImage.path), current_id);
                        }
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.id, (route) => false);
                      }
                    } catch (e) {
                      print(e);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                              content: Text(
                                lang.isSavedLanguage()
                                    ? "Something went Wrong\nMake sure you filled all the fields with their required data"
                                    : "حدث خطأ ما\n تأكد من ادخالك كافة البيانات المطلوبة",
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
                                            color: Colors.redAccent,
                                            fontFamily: 'Jaldi',
                                            fontSize: 16),
                                      )),
                                )
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      ),
    );
  }
}
