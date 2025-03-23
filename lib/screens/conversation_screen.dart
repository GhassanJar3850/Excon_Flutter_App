// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:excon/components/theme_service.dart';
import 'package:excon/connection/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../connection/Routes.dart';
import '../constants.dart';
import '../main.dart';

class ConversationScreen extends StatefulWidget {
  static const String id = 'conversation_screen';

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<ConversationScreen> {
  final messageTextController = TextEditingController();
  Routes routes = Routes();
  Expert chatCtr = Get.put(Expert());

  String messageText = "";
  var messageBubbles = [];
  late ScrollController scrollController;

  @override
  void initState() {
    chatCtr.fetchCurrentChat(current_id, mainCtr.pressedID);
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      chatCtr.fetchCurrentChat(current_id, mainCtr.pressedID);

      if (!mounted) {
        // print('stopped timer');
        chatCtr.messageBubblesObs.clear();
        t.cancel();
      } else {
        // Future.delayed(Duration(milliseconds: 500), () {
        //   scrollController.animateTo(
        //     scrollController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 300),
        //     curve: Curves.decelerate,
        //   );
        // });
      }
    });
    scrollController = ScrollController();
    scrollController.addListener(() {});
    // chatCtr.fetchCurrentChat(current_id, mainCtr.pressedID);
    // scroll(Duration(seconds: 1));

    super.initState();
  }

  void scroll(animDuration) async {
    await Future.delayed(Duration(milliseconds: 1), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: animDuration,
          curve: Curves.decelerate,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var arguments = ModalRoute.of(context)?.settings.arguments as Map;
    // //print(arguments);
    // int otherEndId = arguments['id'];
    return Stack(children: [
      Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/logo.png"),
                  fit: BoxFit.scaleDown,
                  opacity: 0.5,
                  isAntiAlias: true),
            ),
          ),
        ),
      ),
      Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 5,
          leading: null,
          foregroundColor:
              ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
          title: Text(
            lang.isSavedLanguage() ? 'Chat' : "المحادثة",
            style: TextStyle(
              fontSize: 30,
              color: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            reverse: true,
            controller: scrollController,
            slivers: <Widget>[
              Obx(() {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                        title: chatCtr.messageBubblesObs[
                            chatCtr.messageBubblesObs.length - index - 1]),
                    childCount: chatCtr.messageBubblesObs.length,
                  ),
                );
              }),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText:
                            lang.isSavedLanguage() ? 'Message' : 'الرسالة',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeService().isSavedDarkMode()
                                  ? kSecondary
                                  : kPrimary,
                              width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeService().isSavedDarkMode()
                                  ? kSecondary
                                  : kPrimary,
                              width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ThemeService().isSavedDarkMode()
                                  ? kSecondary
                                  : kPrimary,
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var response = json.decode(await routes.sendMessage(
                        current_id, mainCtr.pressedID.value, messageText));
                    setState(() {
                      if (messageText.isNotEmpty &&
                          response['success'] == true) {
                        // print("message sent");
                        messageTextController.clear();
                        chatCtr.messageBubblesObs.add(
                          MessageBubble(
                            sender: lang.isSavedLanguage() ? 'Me' : "أنا",
                            text: messageText,
                            fromMe: true,
                          ),
                        );
                        //scroll to new message
                        //scroll(Duration(milliseconds: 400));
                      }
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    size: 25,
                    color: !ThemeService().isSavedDarkMode() ? kPrimary: kSecondary
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.fromMe});

  final String sender;
  final String text;
  final bool fromMe;

  @override
  Widget build(BuildContext context) {
    bool arabicArrange = lang.isSavedLanguage() ? fromMe : !fromMe;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            arabicArrange ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            !fromMe ? sender : "Me",
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          Material(
            borderRadius: fromMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: fromMe ? Color(0xffcb79ff) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                    color: fromMe ? Colors.white : Colors.black54,
                    fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
