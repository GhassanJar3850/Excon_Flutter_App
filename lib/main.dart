// ignore_for_file: prefer_const_constructors
import 'package:excon/components/language.dart';
import 'package:excon/components/theme_service.dart';
import 'package:excon/connection/db.dart';
import 'package:excon/screens/chats_screen.dart';
import 'package:excon/screens/conversation_screen.dart';
import 'package:excon/screens/favorites_screen.dart';
import 'package:excon/screens/home_screen.dart';
import 'package:excon/screens/loading_screen.dart';
import 'package:excon/screens/login_screen.dart';
import 'package:excon/screens/profile_screen.dart';
import 'package:excon/screens/registration_screen.dart';
import 'package:excon/screens/settings_screen.dart';
import 'package:excon/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(Excon());
}

Language lang = Get.put(Language());
Expert mainCtr = Get.put(Expert());

class Excon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      lang.isEnglish.value = lang.isSavedLanguage();
      return GetMaterialApp(
        textDirection:
            lang.isEnglish.value ? TextDirection.ltr : TextDirection.rtl,
        debugShowCheckedModeBanner: false,
        theme: ThemeService().lightTheme,
        darkTheme: ThemeService().darkTheme,
        themeMode: ThemeService().getThemeMode(),
        initialRoute: Loading.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          Loading.id: (context) => Loading(),
          HomeScreen.id: (context) => HomeScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          ChatsScreen.id: (context) => ChatsScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          FavoritesScreen.id: (context) => FavoritesScreen(),
          ConversationScreen.id: (context) => ConversationScreen(),
        },
      );
    });
  }
}
