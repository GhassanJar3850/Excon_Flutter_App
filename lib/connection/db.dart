// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/chats_screen.dart';
import '../screens/conversation_screen.dart';
import '../screens/home_screen.dart';
import 'Routes.dart';

var current_id = 0;
var current_is_expert = 0;
var current_balance = 0;
var current_consultTypes = [];

class Expert extends GetxController {
  late Routes routes = Routes();
  Map info = {
    'id': "",
    'name': "",
    'rating': "",
    'email': "",
    'phone': "",
    'bio': "",
    'fav': "",
    'service_cost': "",
    'balance': "",
    'location': "",
    'consultations': "",
    'photo_path': "noImage"
  }.obs;

  var pressedID = 0.obs;

  var credentials = [].obs;
  var expertWidgets = [].obs;

  var favCredentials = [].obs;
  var favExpertWidgets = [].obs;

  var chatsCredentials = [].obs;
  var chatsExpertWidgets = [].obs;
  var chatMessages = [].obs;
  var messageBubblesObs = [].obs;

  var engConsultTypes = [];

  var list = [].obs;

  List<bool> AvailableDays = List.generate(7, (_) => false).obs;

  var t1start = TimeOfDay(hour: 1, minute: 0).obs,
      t1end = TimeOfDay(hour: 3, minute: 30).obs;

  var t2start = TimeOfDay(hour: 5, minute: 0).obs,
      t2end = TimeOfDay(hour: 8, minute: 30).obs;

  var canReserve = true.obs;

  void setCanReserve(value) {
    canReserve.value = value;
    update();
  }

  void fetch() async {
    // print('fetching...');
    credentials.clear();
    expertWidgets.clear();

    list.clear();

    list.value = await routes.getAllExperts();

    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        var nestedJson = list[i]['user'];
        var nestedConsultTypes = list[i]['consultations'];

        for (int j = 0; j < nestedConsultTypes.length; j++) {
          engConsultTypes.add(nestedConsultTypes[j]['type_en']);
          // print(engConsultTypes);
        }

        info = {
          'id': nestedJson['id'],
          'name': nestedJson['name'],
          'rating': list[i]['rating_count'] != 0
              ? (2 * list[i]['rating_sum'] / list[i]['rating_count']).floor() /
                  2.0
              : 0.0,
          'email': nestedJson['email'],
          'phone': nestedJson['phone'],
          'bio': list[i]['bio'],
          'fav': list[i]['fav_count'],
          'service_cost': list[i]['service_cost'],
          'balance': nestedJson['balance'],
          'location': list[i]['address'],
          'consultations': engConsultTypes,
          'photo_path': list[i]['photo_path']
        };

        if (nestedJson['id'] != current_id) {
          credentials.add(info);
          expertWidgets.add(
            ExpertInstance(
              information: info,
            ),
          );
        }

        engConsultTypes = [];
      }
    }
    expertWidgets.toSet().toList();
    update();
  }

  List<Widget> appointments = [];

  void fetchAppointments(expert_id) async {
    list.clear();
    list.value = json.decode(await routes.getAppointments(expert_id));
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        var nestedStart = list[i]['start_hour'];
        var nestedEnd = list[i]['start_hour'];
        var nestedUserId = list[i]['start_hour'];
        // print("fetched Appointments");
        appointments.add(Text(nestedUserId));
      }
    }
  }

  void fetchAfterSearch(queue, {consultType = ""}) async {
    // print('fetching search...');
    credentials.clear();
    expertWidgets.clear();
    list.clear();

    list.value =
        json.decode(await routes.search(queue, consultType: consultType));
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        var nestedJson = list[i]["user"];
        var nestedConsultTypes = list[i]['consultations'];

        for (int j = 0; j < nestedConsultTypes.length; j++) {
          engConsultTypes.add(nestedConsultTypes[j]['type_en']);
          // print(engConsultTypes);
        }

        info = {
          'id': nestedJson['id'],
          'name': nestedJson['name'],
          'rating': list[i]['rating_count'] != 0
              ? (2 * list[i]['rating_sum'] / list[i]['rating_count']).floor() /
                  2.0
              : 0.0,
          'email': nestedJson['email'],
          'phone': nestedJson['phone'],
          'bio': list[i]['bio'],
          'fav': list[i]['fav_count'],
          'service_cost': list[i]['service_cost'],
          'balance': nestedJson['balance'],
          'location': list[i]['address'],
          'consultations': engConsultTypes = [],
          'photo_path': list[i]['photo_path']
        };
        if (nestedJson['id'] != current_id) {
          if (!credentials.any((element) => element['id'] == info['id'])) {
            credentials.add(info);
            expertWidgets.add(
              ExpertInstance(
                information: info,
              ),
            );
          }
        }
        engConsultTypes = [];
      }
    }
    update();
  }

  void fetchFavorites(user_id) async {
    // print('fetching favorites...');
    favCredentials.clear();
    favExpertWidgets.clear();
    engConsultTypes.clear();
    list.clear();

    list.value = jsonDecode(await routes.getAllFavorites(user_id));
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        //List<Map> a=jsonDecode(snapshot.data![i]['user']);

        var nestedConsultTypes = list[i]['consultations'];

        for (int j = 0; j < nestedConsultTypes.length; j++) {
          engConsultTypes.add(nestedConsultTypes[j]['type_en']);
          // print(engConsultTypes);
        }

        var nestedJson = list[i]["user"];
        info = {
          'id': nestedJson['id'],
          'name': nestedJson['name'],
          'rating': list[i]['rating_count'] != 0
              ? (2 * list[i]['rating_sum'] / list[i]['rating_count']).floor() /
                  2.0
              : 0.0,
          'email': nestedJson['email'],
          'phone': nestedJson['phone'],
          'bio': list[i]['bio'],
          'fav': list[i]['fav_count'],
          'service_cost': list[i]['service_cost'],
          'balance': nestedJson['balance'],
          'location': list[i]['address'],
          'consultations': engConsultTypes,
          'photo_path': list[i]['photo_path']
        };

        if (nestedJson['id'] != current_id) {
          favCredentials.add(info);
          favExpertWidgets.add(
            ExpertInstance(
              information: info,
            ),
          );
        }
        engConsultTypes = [];
      }
    }
    favExpertWidgets.toSet().toList();
    update();
  }

  void fetchChats(user_id) async {
    // print('fetching chats...$user_id');
    chatsCredentials.clear();
    chatsExpertWidgets.clear();
    list.clear();
    //chatMessages.clear();

    list.value = json.decode(await routes.getAllChats(user_id));
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        //List<Map> a=jsonDecode(snapshot.data![i]['user']);
        //var nestedJson = list[i]["user"];
        var id = (list[i]['user_2_id'] == current_id)
            ? list[i]['user_1_id']
            : list[i]['user_2_id'];
        // chatMessages.value = list[i]['messages'];
        //   print("these are the messages $chatMessages");
        info = {
          'id': id,
          'name': list[i]['other_user_name'],
          'photo_path': "profile_photos/$id.jpg"
          //TODO: add the consultTypes
        };

        if (id != current_id && info['id'] != null) {
          chatsCredentials.add(info);
          chatsExpertWidgets.add(
            ChatInstance(
              information: info,
              messages: chatMessages,
            ),
          );
        }
      }
    } else {
      // print("empty list");
    }
    chatsExpertWidgets.toSet().toList();
    update();
  }

  void fetchCurrentChat(sender, receiver) async {
    // print('fetching current chat between $sender and $receiver');

    chatsCredentials.clear();
    messageBubblesObs.clear();
    list.clear();

    list.value = json.decode(await routes.getChat(sender, receiver));
    if (list.isNotEmpty) {
      var id = (list[0]['other_user_id'] != current_id)
          ? current_id
          : list[0]['other_user_id'];

      chatMessages.clear();
      chatMessages.value = list[0]['chat'];
      //print("these are the messages $chatMessages");
      info = {
        'id': id,
        'name': list[0]['other_user_name'],
        //TODO: add the consultTypes
      };

      if (chatMessages.isNotEmpty) {
        for (int i = 0; i < chatMessages.length; i++) {
          messageBubblesObs.add(MessageBubble(
              sender: list[0]["other_user_name"],
              text: chatMessages[i]["content"],
              fromMe:
                  (chatMessages[i]['sender_id'] == current_id) ? true : false));
        }
      }

      if (id != current_id && info['id'] != null) {
        chatsCredentials.add(info);
        chatsExpertWidgets.add(
          ChatInstance(
            information: info,
            messages: chatMessages.value,
          ),
        );
      }
    } else {
      // print("empty list");
    }
    chatsExpertWidgets.toSet().toList();

    update();
  }
}

class CurrentUser extends GetxController {
  var curr_name = "Default Name".obs;
  var curr_email = "Default Email".obs;
  var curr_rating = 0.0.obs;
  var curr_balance = 0.obs;
  var curr_phone = "(+963) 937 761 225".obs;
  var curr_favCount = 0.obs;
  var curr_location = "Default Location".obs;
  var curr_bio = "Default Bio".obs;
  var curr_id = 0.obs;
  var curr_is_expert = 0.obs;
  var curr_consultTypes = [].obs;

  void loadExpertCredentials(
      name, email, phone, balance, bio, location, id, isExpert, consultTypes) {
    curr_name.value = name;
    curr_email.value = email;
    curr_balance.value = balance;
    curr_phone.value = phone;
    curr_bio.value = bio;
    curr_location.value = location;
    curr_id.value = id;
    curr_is_expert.value = isExpert;
    curr_consultTypes.value = consultTypes;
    update();
  }

  void loadUserCredentials(name, email, phone, balance, id) {
    curr_name.value = name;
    curr_email.value = email;
    curr_balance.value = balance;
    curr_phone.value = phone;
    curr_id.value = id;
    update();
  }
}
