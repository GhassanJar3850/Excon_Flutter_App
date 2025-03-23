// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'main.dart';

Color kPrimary = const Color.fromARGB(255, 27, 27, 27);
Color kSecondary = Colors.white;
double kCornerRoundness = 20;
MediaQueryData phoneData =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window);
double screenHeight = phoneData.size.height;
double screenWidth = phoneData.size.width;

Map<String, IconData> mappedConsultTypes = {
  "Tech": Icons.laptop,
  "Legal": Icons.account_balance,
  "Medical": Icons.medical_services_outlined,
  "Vocational": Icons.work_outline,
  "تقنية": Icons.laptop,
  "قانونية": Icons.account_balance,
  "طبية": Icons.medical_services_outlined,
  "مهنية": Icons.work_outline
};

List ConsultationsToText(value) {
  List temp = [];
  List Consultations = ["Tech", "Legal", "Medical", "Vocational"];
  for (int i = 0; i < value.length; i++) {
    value[i] ? temp.add(Consultations[i]) : null;
  }
  return temp;
}

List<Widget> hours = [
  Text("1"),
  Text("2"),
  Text("3"),
  Text("4"),
  Text("5"),
  Text("6"),
  Text("7"),
  Text("8"),
  Text("9"),
  Text("10"),
  Text("11"),
  Text("12"),
  Text("13"),
  Text("14"),
  Text("15"),
  Text("16"),
  Text("17"),
  Text("18"),
  Text("19"),
  Text("20"),
  Text("21"),
  Text("22"),
  Text("23"),
  Text("24"),
];

var url="http://10.0.2.2:8000/";

ButtonStyle lang_toggled = ButtonStyle(
  //side: MaterialStateProperty.all(BorderSide(color: kSecondary, width: 2)),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10)))),
  //overlayColor: MaterialStateProperty.all(kPrimary),
  minimumSize: MaterialStateProperty.all(Size(0.5, 0.5)),
);

ButtonStyle lang_untoggled = ButtonStyle(
  shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)))),
  //overlayColor: MaterialStateProperty.all(kPrimary),
  minimumSize: MaterialStateProperty.all(Size(0.5, 1)),
);

const kSendButtonTextStyle = TextStyle(
  // color: Color(0xffcb79ff),
  color: Colors.amber,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Message',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(
      color: Color(0xffcb79ff),
    ),
  ),
);
