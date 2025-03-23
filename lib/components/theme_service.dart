// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(27, 27, 27, .1),
  100: Color.fromRGBO(27, 27, 27, .2),
  200: Color.fromRGBO(27, 27, 27, .3),
  300: Color.fromRGBO(27, 27, 27, .4),
  400: Color.fromRGBO(27, 27, 27, .5),
  500: Color.fromRGBO(27, 27, 27, .6),
  600: Color.fromRGBO(27, 27, 27, .7),
  700: Color.fromRGBO(27, 27, 27, .8),
  800: Color.fromRGBO(27, 27, 27, .9),
  900: Color.fromRGBO(27, 27, 27, 1),
};
MaterialColor customColor1 = MaterialColor(0xFF1b1b1b, color);
MaterialColor customColor2 = MaterialColor(0xffffffff, color);

ThemeData themeData(bool isDarkTheme) {
  return ThemeData(
    fontFamily: 'Jaldi',
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        borderSide: BorderSide(
          width: 2,
          color: isDarkTheme ? kSecondary : kPrimary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: isDarkTheme ? kSecondary : kPrimary, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
    ),
    primaryColor: isDarkTheme ? kPrimary : kSecondary,
    indicatorColor: isDarkTheme ? kPrimary : kSecondary,
    hintColor: isDarkTheme ? kPrimary : kSecondary,
    highlightColor: isDarkTheme ? kPrimary : Color(0xffe8e8e8),
    hoverColor: isDarkTheme ? kSecondary : Colors.white,
    focusColor: isDarkTheme ? kPrimary : kSecondary,
    disabledColor: Colors.grey,
    cardColor: isDarkTheme ? Color(0xFF1B1B1B) : Colors.white,
    canvasColor: isDarkTheme ? kPrimary : Colors.grey[50],
    shadowColor: isDarkTheme ? kPrimary : kPrimary,
    scaffoldBackgroundColor: isDarkTheme //? kPrimary
        ? Color.fromARGB(255, 29, 29, 29)
        : Color.fromARGB(255, 255, 255, 255),
    // buttonTheme: Theme.of(context).buttonTheme.copyWith(
    //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    appBarTheme: AppBarTheme(
      color: isDarkTheme ? kPrimary : kSecondary,
      shadowColor: isDarkTheme ? kPrimary : kPrimary,
      elevation: 0.0,
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            shadowColor: MaterialStateProperty.all(
              isDarkTheme ? Colors.black : kPrimary,
            ),
            textStyle: MaterialStateProperty.all(TextStyle(
              color: isDarkTheme ? kSecondary : kPrimary,
            )),
            backgroundColor: MaterialStateProperty.all(
              isDarkTheme ? kPrimary : kSecondary,
            ))),
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: isDarkTheme ? kSecondary : kPrimary),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: isDarkTheme ? kPrimary : kSecondary,
    ),
    iconTheme: IconThemeData(
      color: !isDarkTheme ? kSecondary : kPrimary,
      opacity: 1,
    ),
    tabBarTheme: TabBarTheme(
      dividerHeight: 0,
      labelStyle: TextStyle(fontSize: 18, fontFamily: "Jaldi"),
      unselectedLabelStyle: TextStyle(
          fontSize: 17, fontFamily: "Jaldi", overflow: TextOverflow.ellipsis),
    ),
    dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCornerRoundness)),
        backgroundColor: isDarkTheme ? kPrimary : kSecondary,
        titleTextStyle: TextStyle(
            fontSize: 30,
            fontFamily: 'Jaldi',
            color: isDarkTheme ? kSecondary : kPrimary),
        contentTextStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'Jaldi',
            color: isDarkTheme ? kSecondary : kPrimary),
        alignment: Alignment.center), colorScheme: isDarkTheme
        ? ColorScheme.dark().copyWith(
            primary: kSecondary,
            secondary: Colors.grey,
            brightness: Brightness.dark)
        : ColorScheme.light().copyWith(
            primary: kPrimary,
            secondary: Colors.grey,
            brightness: Brightness.light,
          ).copyWith(primary: isDarkTheme ? customColor2 : customColor1, background: isDarkTheme ? kPrimary : Color(0xffF1F5FB)),
  );
}

class ThemeService {
  final lightTheme = themeData(false);
  final darkTheme = themeData(true);

  final getStorage = GetStorage();
  final darkThemeKey = 'isDarkTheme';

  void saveTheme(bool isDark) {
    getStorage.write(darkThemeKey, isDark);
  }

  bool isSavedDarkMode() {
    return getStorage.read(darkThemeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveTheme(!isSavedDarkMode());
  }
}

// class LanguageService {
//   bool isArabic = true;
//
//   final getStorage = GetStorage();
//   final ArabicLangKey = 'isArabic';
//
//   void saveLang(bool isArabic) {
//     getStorage.write(ArabicLangKey, isArabic);
//   }
//
//   bool isSavedArabic() {
//     return getStorage.read(ArabicLangKey) ?? false;
//   }
//
//   bool getLang() {
//     return isSavedArabic() ? isArabic: !isArabic;
//   }
//
//   void changeLang() {
//     isArabic=!isSavedArabic();
//     saveLang(!isSavedArabic());
//   }
// }
