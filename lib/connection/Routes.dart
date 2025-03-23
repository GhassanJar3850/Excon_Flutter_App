// ignore_for_file: non_constant_identifier_names

import "dart:convert";
import 'dart:io';

import 'package:excon/connection/db.dart';
import "package:http/http.dart" as http;

class Routes {
  var baseUrl = "http://10.0.2.2:8000/api";

  Future<List> getAllExperts() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/experts/?user_id=$current_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      //print("error from route");
      return Future.error(e);
    }
  }

  Future pushUser(String name, String email, String password, String phone,
      serviceCost, String location, String bio, consultations) async {
    try {
      Map data = {
        "name": name,
        "address": location,
        "phone": phone,
        "service_cost": serviceCost,
        "bio": bio,
        "email": email,
        "password": password,
        "consultations": consultations,
      };

      var body = jsonEncode(data);
      var response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
        body: body,
      );

      //print(response.statusCode);
      //print(response.body);
      return response;
    } catch (e) {
      Future.error(e);
    }
  }

  Future logIn(String email, String password) async {
    try {
      Map data = {
        "email": email,
        "password": password,
      };
      // print(data);

      var body = json.encode(data);
      var response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
        body: body,
      );

      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future logOut() async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );
      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future pay(user_id, expert_id) async {
    try {
      Map data = {
        "user_id": user_id,
        "expert_id": expert_id,
      };

      var body = jsonEncode(data);
      var response = await http.post(Uri.parse("$baseUrl/pay"),
          headers: {
            "Content-Type": "application/json",
            "Charset": "utf8_bin",
            "Accept": "application/json"
          },
          body: body);
      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future search(String queue, {String consultType = ""}) async {
    try {
      var response = await http.get(
        Uri.parse(
            "$baseUrl/experts/?search=$queue&consulttype=$consultType&user_id=$current_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );

      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future rateExpert(rating, expert_id, user_id) async {
    try {
      Map data = {"expert_id": expert_id, "user_id": user_id, "rating": rating};
      var body = jsonEncode(data);
      var response = await http.post(
        Uri.parse("$baseUrl/expert/updaterating/"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Accept": "application/json"
        },
        body: body,
      );
      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future addFavorite(sender, receiver) async {
    try {
      Map data = {"user_id": sender, "expert_id": receiver};
      var body = jsonEncode(data);
      var response = await http.post(
        Uri.parse("$baseUrl/user/changefavorite/"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
        body: body,
      );
      //print("from $sender to $receiver, statusCode: ${response.statusCode}");
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future getAllFavorites(user_id) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/user/favorites/?user_id=$user_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );

      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future getChat(user_id, expert_id) async {
    try {
      var response = await http.get(
        Uri.parse(
            "$baseUrl/chat/?curr_user_id=$user_id&other_user_id=$expert_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );
      //print(response.statusCode);
      //print(response.body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body;
      } else {
        return Future.error("no messages");
      }
    } catch (e) {
      Future.error(e);
    }
  }

  Future getAllChats(user_id) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/user/chats/?user_id=$user_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );

      //print(response.statusCode);
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future sendMessage(sender, receiver, content) async {
    try {
      Map data = {
        "sender_id": sender,
        "receiver_id": receiver,
        "content": content
      };
      var body = jsonEncode(data);
      var response = await http.post(
        Uri.parse("$baseUrl/user/sendmessage/"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
        body: body,
      );
      //print("from $sender to $receiver, statusCode: ${response.statusCode}");
      //print(response.body);
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future uploadImage(File uploadImage, int expert_id) async {
    try {
      String addimageUrl =
          "$baseUrl/expert/uploadprofilephoto/?expert_id=$expert_id";
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      };

      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..headers.addAll(headers)
        ..files.add(
          await http.MultipartFile.fromPath('profile_photo', uploadImage.path),
        );
      var response = await request.send();

      // print(response.statusCode.toString());

      return true;
    } catch (e) {
      print(e);
    }
  }

  // Appointment & Reservation Routes
  Future getAppointments(expert_id) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/expert/appointments/?expert_id=$expert_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future updateSchedule(expert_id, st1, st2, et1, et2, avDays) async {
    try {
      Map data = {
        "expert_id": expert_id,
        "start_time_1": st1,
        "end_time_1": et1,
        "start_time_2": st2,
        "end_time_2": et2,
        "days": avDays,
      };
      var body = jsonEncode(data);
      var response = await http.post(
        Uri.parse("$baseUrl/user/updateSchedule/"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
        body: body,
      );
      print(expert_id);
      print(st1);
      print(st2);
      print(et1);
      print(et2);
      print(avDays);
      print(body);

      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future getIsAvailable(expert_id) async {
    try {
      Map data = {
        "expert_id": expert_id,
      };
      var body = jsonEncode(data);
      var response = await http.get(
        Uri.parse("$baseUrl/expert/upcomingcalendar/?expert_id=$expert_id"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }

  Future getAvailableHours(expert_id, date) async {
    try {
      Map data = {
        "expert_id": expert_id,
      };
      var body = jsonEncode(data);
      var response = await http.get(
        Uri.parse(
            "$baseUrl/expert/availablehours/?expert_id=$expert_id&date=$date"),
        headers: {
          "Content-Type": "application/json",
          "Charset": "utf8_bin",
          "Accept": "application/json"
        },
      );
      return response.body;
    } catch (e) {
      Future.error(e);
    }
  }
}
