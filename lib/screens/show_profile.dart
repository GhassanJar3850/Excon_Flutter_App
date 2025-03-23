// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:excon/components/theme_service.dart';
import 'package:excon/connection/db.dart';
import 'package:excon/constants.dart';
import 'package:excon/screens/conversation_screen.dart';
import 'package:excon/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../components/rounded_button.dart';
import '../connection/Routes.dart';
import '../main.dart';

class ShowProfile extends StatefulWidget {
  ShowProfile(BuildContext context,
      {required this.balance,
      required this.favCount,
      required this.rating,
      required this.name,
      required this.location,
      required this.email,
      required this.phone,
      required this.bio,
      required this.id,
      required this.serviceCost,
      required this.consultations,
      required this.photo_path});

  final int id;
  final String name;
  final int balance;
  final int favCount;
  final double rating;
  final String location;
  final String email;
  final String phone;
  final String bio;
  final int serviceCost;
  final consultations;
  final String photo_path;

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile>
    with TickerProviderStateMixin {
  Routes expert = Routes();
  Expert chat = Expert();
  int rating = 2;
  bool favorite_pressed = false;
  late TabController showProfileTabController;

  @override
  void initState() {
    showProfileTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    showProfileTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 12, right: 12),
      height: 650,
      decoration: BoxDecoration(
        color: ThemeService().isSavedDarkMode() ? kPrimary : kSecondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile Picture + {name, spec, attributes}
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Pic
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.amber, Colors.purple]),
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: !widget.photo_path.contains("\\")
                            ? Image(
                                height: 200,
                                width: 200,
                                image:
                                    NetworkImage("${url}${widget.photo_path}"),
                              )
                            : Image.asset(
                                'images/profile2.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),

                // Name, specs , attributes
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      // Name
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 24),
                      ),

                      // Specializations
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0;
                              i < widget.consultations.length;
                              i++) ...[
                            SpecializationTag(
                              icon:
                                  mappedConsultTypes[widget.consultations[i]]!,
                            )
                          ]
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 100,
                      ),

                      // Attributes {rating, fav, wallet}
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 21,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  '${widget.rating}',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Jaldi'),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  '${widget.favCount}',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Jaldi'),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: Color(0xff00a30b),
                                size: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  '${widget.serviceCost}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Jaldi',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 400,
            width: 600,
            child: TabBarView(
              controller: showProfileTabController,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 2, right: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(kCornerRoundness),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeService().isSavedDarkMode()
                                ? kPrimary
                                : kSecondary,
                            borderRadius:
                                BorderRadius.circular(kCornerRoundness),
                          ),
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    lang.isSavedLanguage()
                                        ? 'Biography'
                                        : "الوصف",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      dragStartBehavior: DragStartBehavior.down,
                                      child: Text(
                                        widget.bio,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                        width: 150.0,
                      ),

                      // Other INFO
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kCornerRoundness)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone_iphone,
                          ),
                          title: Text(
                            widget.phone,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kCornerRoundness)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                        child: ListTile(
                          leading: Icon(
                            Icons.mail,
                          ),
                          title: Text(widget.email,
                              style: TextStyle(
                                fontSize: 15,
                              )),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kCornerRoundness)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on_rounded,
                          ),
                          title: Text(widget.location,
                              style: TextStyle(
                                fontSize: 15,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0, left: 1, right: 1),
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 10),
                //         child: ToggleButtons(
                //           constraints:
                //               BoxConstraints(minWidth: 45, minHeight: 40),
                //           selectedColor: Colors.amber,
                //           fillColor: Color.fromARGB(70, 198, 26, 255),
                //           borderRadius:
                //               BorderRadius.circular(kCornerRoundness - 10),
                //           isSelected: consultTypes,
                //           onPressed: (int index) {
                //             setState(() {
                //               consultTypes[index] = !consultTypes[index];
                //             });
                //           },
                //           children: weekDays,
                //         ),
                //       ),
                //
                //       // time 1
                //       Text(
                //         lang.isSavedLanguage() ? "First Period" : "التوقيت الأول",
                //         style: TextStyle(fontSize: 25),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Text(
                //             lang.isSavedLanguage() ? "From:" : "من",
                //             style: TextStyle(
                //               fontSize: 20,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 70,
                //             height: 80,
                //             child: CupertinoPicker(
                //                 squeeze: 0.8,
                //                 magnification: 1.4,
                //                 itemExtent: 22,
                //                 onSelectedItemChanged: (value) {
                //                   print(value + 1);
                //                 },
                //                 children: hours),
                //           ),
                //           Text(
                //             lang.isSavedLanguage() ? "To:" : "إلى",
                //             style: TextStyle(
                //               fontSize: 20,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 70,
                //             height: 80,
                //             child: CupertinoPicker(
                //                 squeeze: 0.8,
                //                 magnification: 1.4,
                //                 itemExtent: 22,
                //                 onSelectedItemChanged: (value) {
                //                   print(value + 1);
                //                 },
                //                 children: hours),
                //           ),
                //         ],
                //       ),
                //
                //       Divider(
                //         height: 20,
                //         color: Colors.purple,
                //         indent: 40,
                //         endIndent: 40,
                //       ),
                //       // time 2
                //       Text(
                //         lang.isSavedLanguage()
                //             ? "Second Period"
                //             : "التوقيت الثاني",
                //         style: TextStyle(fontSize: 25),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Text(
                //             lang.isSavedLanguage() ? "From:" : "من",
                //             style: TextStyle(
                //               fontSize: 20,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 70,
                //             height: 80,
                //             child: CupertinoPicker(
                //                 squeeze: 0.8,
                //                 magnification: 1.4,
                //                 itemExtent: 22,
                //                 onSelectedItemChanged: (value) {
                //                   print(value + 1);
                //                 },
                //                 children: hours),
                //           ),
                //           Text(
                //             lang.isSavedLanguage() ? "To:" : "إلى",
                //             style: TextStyle(
                //               fontSize: 20,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 70,
                //             height: 80,
                //             child: CupertinoPicker(
                //                 squeeze: 0.8,
                //                 magnification: 1.4,
                //                 itemExtent: 22,
                //                 onSelectedItemChanged: (value) {
                //                   print(value + 1);
                //                 },
                //                 children: hours),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Column(
                  children: [
                    CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 1),
                      lastDate: DateTime(2025, 12, 2),
                      onDateChanged: (value) {
                        //print(value);
                      },
                      selectableDayPredicate: (value) {
                        //print(value);
                        return true;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'From   [ ${mainCtr.t1start.value.hour} ]',
                          style: TextStyle(fontSize: 21),
                        ),
                        Text(
                          'To   [ ${mainCtr.t1start.value.hour + 2} ]',
                          style: TextStyle(fontSize: 21),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  if (!favorite_pressed) {
                    var response = json.decode(
                      await expert.addFavorite(current_id, widget.id),
                    );
                    if (response['success']) {
                      print('added to favorites');
                      setState(() {
                        favorite_pressed = true;
                      });
                    } else {
                      print('error');
                    }
                  }
                },
                icon: Icon(
                  favorite_pressed ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                  color: Colors.redAccent,
                ),
              ),
              RoundedButton(
                title: lang.isSavedLanguage() ? 'Chat' : "محادثة",
                onPressed: () {
                  // chat.fetchCurrentChat(current_id, widget.id);
                  //print(chat.chatMessages.value);
                  Navigator.pushNamed(context, ConversationScreen.id,
                      arguments: {
                        'id': widget.id,
                        'messages': chat.chatMessages,
                      });
                },
              ),
              RoundedButton(
                title: lang.isSavedLanguage() ? 'Reserve' : "حجز موعد",
                onPressed: () {
                  Get.defaultDialog(
                    title: lang.isSavedLanguage()
                        ? "Schedule of ${widget.name}"
                        : "جدول مواعيد ${widget.name}",
                    backgroundColor: ThemeService().isSavedDarkMode()
                        ? kPrimary
                        : kSecondary,
                    content: SizedBox(
                      height: 470,
                      width: 500,
                      child: Obx(() {
                        return Column(
                          children: [
                            SfCalendar(
                              view: CalendarView.month,
                              allowDragAndDrop: true,
                              dataSource:
                                  MeetingDataSource(calendarDataSource()),
                              monthViewSettings: MonthViewSettings(
                                  appointmentDisplayMode:
                                      MonthAppointmentDisplayMode.indicator),
                              allowAppointmentResize: true,
                            ),
                            Text(
                                lang.isSavedLanguage()
                                    ? "Work Periods:"
                                    : "أوقات العمل:",
                                style: TextStyle(fontSize: 22)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                            lang.isSavedLanguage()
                                                ? "Proceed to Reserve an Appointment?"
                                                : "تأكيد حجز موعد؟",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    print(widget.serviceCost);
                                                    print(current_balance);
                                                    setState(() {
                                                      if (widget.serviceCost >
                                                          current_balance) {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 40,
                                                                ),
                                                                content: Text(
                                                                  lang.isSavedLanguage()
                                                                      ? "Insufficient balance"
                                                                      : "رصيد الحساب غير كافٍ",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                              );
                                                            });
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    lang.isSavedLanguage()
                                                        ? 'Confirm'
                                                        : "تأكيد",
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
                                                    lang.isSavedLanguage()
                                                        ? 'Decline'
                                                        : "رجوع",
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
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: Color(0xf7131313),
                                        borderRadius: BorderRadius.circular(
                                            kCornerRoundness)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(lang.isSavedLanguage()
                                                ? "From"
                                                : "من"),
                                            Text(
                                              "${mainCtr.t1start.value.hour}",
                                              style: TextStyle(
                                                  color: Colors.amber),
                                            ),
                                            Text(lang.isSavedLanguage()
                                                ? "to"
                                                : "إلى"),
                                            Text(
                                              "${mainCtr.t1end.value.hour}",
                                              style: TextStyle(
                                                  color: Colors.amber),
                                            ),
                                          ],
                                        ),
                                        mainCtr.canReserve.value
                                            ? Text(
                                                lang.isSavedLanguage()
                                                    ? "Available"
                                                    : "متاح",
                                                style: TextStyle(
                                                    color: Colors.lightGreen,
                                                    fontFamily: 'Jaldi',
                                                    fontSize: 20),
                                              )
                                            : Text(
                                                lang.isSavedLanguage()
                                                    ? "Reserved"
                                                    : "محجوز",
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontFamily: 'Jaldi',
                                                    fontSize: 20),
                                              ),
                                        Container(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                            lang.isSavedLanguage()
                                                ? "Proceed to Reserve an Appointment?"
                                                : "تأكيد حجز موعد؟",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    print(widget.serviceCost);
                                                    print(current_balance);
                                                    setState(() {
                                                      if (widget.serviceCost >
                                                          current_balance) {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                              return AlertDialog(
                                                                title: Icon(
                                                                  Icons
                                                                      .info_outline,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 40,
                                                                ),
                                                                content: Text(
                                                                  lang.isSavedLanguage()
                                                                      ? "Insufficient balance"
                                                                      : "رصيد الحساب غير كافٍ",
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      20),
                                                                ),
                                                              );
                                                            });
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    lang.isSavedLanguage()
                                                        ? 'Confirm'
                                                        : "تأكيد",
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
                                                    lang.isSavedLanguage()
                                                        ? 'Decline'
                                                        : "رجوع",
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
                                  child: Container(
                                    height: 110,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: Color(0xf7131313),
                                        borderRadius: BorderRadius.circular(
                                            kCornerRoundness)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(lang.isSavedLanguage()
                                                ? "From"
                                                : "من"),
                                            Text(
                                              "${mainCtr.t2start.value.hour}",
                                              style:
                                                  TextStyle(color: Colors.amber),
                                            ),
                                            Text(lang.isSavedLanguage()
                                                ? "to"
                                                : "إلى"),
                                            Text(
                                              "${mainCtr.t2end.value.hour}",
                                              style:
                                                  TextStyle(color: Colors.amber),
                                            ),
                                          ],
                                        ),
                                        mainCtr.canReserve.value
                                            ? Text(
                                                lang.isSavedLanguage()
                                                    ? "Available"
                                                    : "متاح",
                                                style: TextStyle(
                                                    color: Colors.lightGreen,
                                                    fontFamily: 'Jaldi',
                                                    fontSize: 20),
                                              )
                                            : Text(
                                                lang.isSavedLanguage()
                                                    ? "Reserved"
                                                    : "محجوز",
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontFamily: 'Jaldi',
                                                    fontSize: 20),
                                              ),
                                        Container(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                    confirm: TextButton(
                      onPressed: () {
                        mainCtr.setCanReserve(!mainCtr.canReserve.value);
                        print(mainCtr.canReserve.value);
                      },
                      child: Text(
                        lang.isSavedLanguage() ? "Cancel" : "رجوع",
                        style: TextStyle(
                            color: Colors.amber,
                            fontFamily: 'Jaldi',
                            fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 50,
                width: 37,
                child: DropdownButton<int>(
                  value: rating,
                  isExpanded: true,
                  iconSize: 25,
                  icon: Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemHeight: 48,
                  underline: Divider(
                    thickness: 1,
                    height: 2,
                    color: Colors.amber,
                  ),
                  items: <int>[5, 4, 3, 2, 1]
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        "$value",
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  }).toList(),
                  onChanged: (int? newValue) async {
                    setState(() {
                      rating = newValue!;
                    });
                    print("the expert you are trying to rate ${widget.id}");
                    var response = json.decode(
                        await expert.rateExpert(rating, widget.id, current_id));
                    if (response['success'] == true) {
                      print('rated');
                    } else {
                      print('error');
                    }
                    // var response = jsonDecode(await expert.logOut());
                    // if (response['status'] == "success") {
                    //   print('added');
                    // } else {
                    //   print('error');
                    // }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

List<Meeting> calendarDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(
      today.year, today.month, today.add(Duration(days: 2)).day, 9, 0, 0);

  final DateTime endTime = startTime.add(const Duration());
  meetings.add(Meeting(
      'First Period', startTime, endTime, const Color(0xFF0F8644), false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].Reserved;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.Reserved);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool Reserved;
}

// showDatePicker(
//   helpText: 'Select an Available Date',
//   confirmText: 'Reserve',
//   cancelText: 'Cancel',
//   context: context,
//   initialDate: DateTime.now(),
//   firstDate: DateTime(2023, 1),
//   lastDate: DateTime(2024, 12, 2),
//
// );
//   showDateRangePicker(
//       context: context,
//       firstDate: DateTime( 2023, 1,1,1),
//       lastDate: DateTime(2023, 2, 2,1));

//SfCalendar();
