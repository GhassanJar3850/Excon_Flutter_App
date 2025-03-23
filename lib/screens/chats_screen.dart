// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/theme_service.dart';
import '../connection/db.dart';
import '../constants.dart';
import '../main.dart';
import 'conversation_screen.dart';

class ChatsScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Expert expertCtr = Get.put(Expert());

  @override
  void initState() {
    expertCtr.fetchChats(current_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shadowColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            surfaceTintColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            foregroundColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
            backgroundColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,

            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            forceElevated: true,
            elevation: 5,
            pinned: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
            title: Text(
              lang.isSavedLanguage() ? 'Chats' : "المحادثات",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Jaldi',
                color: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
              ),
            ),
          ),
          Obx(() {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    title: expertCtr.chatsExpertWidgets[expertCtr.chatsExpertWidgets.length-index-1]),
                childCount: expertCtr.chatsExpertWidgets.length,
              ),
            );
          }),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}

class ChatInstance extends StatelessWidget {
  ChatInstance({required this.information, this.messages});

  var messages;
  Map information = {
    "name": "",
    "id": 0,
    "photo_path":"noImage"
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(kCornerRoundness),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kCornerRoundness),
        ),
        padding: EdgeInsets.all(10.0),
        height: 100,
        width: 50,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            mainCtr.pressedID.value = information['id'];
            //print(messages.value);
            Navigator.pushNamed(context, ConversationScreen.id);
          },
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      "$url${information['photo_path']}",
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/profile2.png',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                )

              ),
              Expanded(
                flex: 10,
                child: Text(
                  information['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jaldi',
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
