// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:excon/constants.dart';
import 'package:flutter/material.dart';

import '../components/setting_card.dart';
import '../components/theme_service.dart';
import '../connection/Routes.dart';
import '../main.dart';
import 'loading_screen.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'settings_screen';

  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool bruh = false;
  Routes expert = Routes();

  @override
  Widget build(BuildContext context) {
    List<Widget> settings = [
      //Dark mode
      Setting(
        text: lang.isSavedLanguage() ? 'Dark Mode' : "الوضع الداكن",
        onPressed: (value) {
          setState(() {
            ThemeService().changeTheme();
          });
        },
        toggleValue: ThemeService().isSavedDarkMode(),
        toggleSetting: true,
        child: Container(),
      ),

      //Language
      Setting(
        text: lang.isSavedLanguage() ? 'Language' : "اللغة",
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.only(right: 9.0, left: 9.0),
          child: DropdownButton<String>(

            value: lang.isSavedLanguage() ? 'English' : "العربية",
            isExpanded: true,
            borderRadius: BorderRadius.circular(kCornerRoundness),
            iconSize: 16,
            icon: Icon(Icons.language),

            itemHeight: 48,
            underline: Divider(
              color: Colors.purpleAccent,
              height: 2,
            ),
            items: <String>['English', "العربية"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 17),
                ),
              );
            }).toList(),

            onChanged: (String? newValue) {
              setState(() {
                lang.changeLang(newValue == "English");
              });
            },
          ),
        ),
      ),

      //About
      Setting(
        text: lang.isSavedLanguage() ? 'About EXcon' : "حول EXcon",
        onPressed: () {
          //TODO: implement navigating to our about page :)

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: SizedBox(
                height: 340,
                child: Column(
                  children: [
                    Image.asset("images/GKKQ.jpg"),
                    Text(
                      lang.isSavedLanguage()
                          ? "Developed by GKKQ Group"
                          : "قامت مجموعة GKKQ بتطوير هذا التطبيق",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ));
            },
          );
        },
        child: Icon(
          Icons.info_outline,
          size: 25,
        ),
      ),

      //Log out
      Setting(
          text: lang.isSavedLanguage() ? 'Log out' : "تسجيل الخروج",
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    lang.isSavedLanguage() ? "Log out?" : "تسجيل الخروج؟",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var response = jsonDecode(await expert.logOut());
                            if (response['status'] == "success") {
                              Navigator.restorablePushReplacementNamed(
                                  context, Loading.id);
                            } else {
                              print('error');
                            }
                          },
                          child: Text(
                            lang.isSavedLanguage() ? 'Confirm' : "تأكيد",
                            style: TextStyle(
                                color: Colors.amber,
                                fontFamily: 'Jaldi',
                                fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            lang.isSavedLanguage() ? 'Decline' : "رجوع",
                            style: TextStyle(
                                color: Colors.amber,
                                fontFamily: 'Jaldi',
                                fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.door_front_door_outlined,
            size: 25,
          )),
    ];
    return Scaffold(
      // backgroundColor: !kSwitched
      //     ? Color.fromARGB(255, 250, 250, 250)
      //     : Color.fromARGB(255, 3, 3, 3),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            forceElevated: true,
            elevation: 5,
            shadowColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            surfaceTintColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            foregroundColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            backgroundColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            // forceMaterialTransparency: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(kCornerRoundness),
                bottomRight: Radius.circular(kCornerRoundness),
              ),
            ),
            title: Text(
              lang.isSavedLanguage() ? 'Settings' : 'الإعدادات',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Jaldi',
                color: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                      title: settings[index],
                    ),
                childCount: settings.length),
          ),
        ],
      ),
    );
  }
}
