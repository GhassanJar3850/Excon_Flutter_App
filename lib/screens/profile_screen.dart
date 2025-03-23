// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:excon/connection/db.dart';
import 'package:excon/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../components/theme_service.dart';
import '../connection/Routes.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

CurrentUser cUserCtr = Get.put(CurrentUser());

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController profileTabController;
  Expert expert = Get.put(Expert());
  Routes routes = Routes();
  List<Widget> weekDays = [
    Text(lang.isSavedLanguage() ? "Sun" : 'الأحد'),
    Text(lang.isSavedLanguage() ? "Mon" : 'الإثنين'),
    Text(lang.isSavedLanguage() ? "Tue" : 'الثلاثاء'),
    Text(lang.isSavedLanguage() ? "Wed" : 'الأربعاء'),
    Text(lang.isSavedLanguage() ? "Thu" : 'الخميس'),
    Text(lang.isSavedLanguage() ? "Fri" : 'الجمعة'),
    Text(lang.isSavedLanguage() ? "Sat" : 'السبت'),
  ];

  @override
  void initState() {
    profileTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    expert.fetchAppointments(current_id);
    super.initState();
  }

  @override
  void dispose() {
    profileTabController.dispose();
    super.dispose();
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
            pinned: true,
            elevation: 5,
            title: Text(
              lang.isSavedLanguage() ? ' Profile' : "الحساب",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Jaldi',
                color: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // print(current_consultTypes);
                  },
                  child: Icon(Icons.edit))
            ],

            leadingWidth: 1000,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            // flexibleSpace: Padding(
            //   padding: const EdgeInsets.only(
            //       top: 50.0, left: 20, bottom: 10, right: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'Profile',
            //         style: TextStyle(fontSize: 40, fontFamily: 'Jaldi'),
            //       ),
            //
            //     ],
            //   ),
            // ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // About
                    if (current_is_expert == 1) ...[
                      // profile pic & username
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Profile Pic
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.amber, Colors.purple]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.network(
                                    '${url}profile_photos/$current_id.jpg',
                                    errorBuilder:
                                        (context, exception, stackTrace) {
                                      return Image.asset('images/profile2.png');
                                    },
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
                                  cUserCtr.curr_name.value,
                                  style: TextStyle(fontSize: 30),
                                ),

                                // Specializations
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (int i = 0;
                                        i < current_consultTypes.length;
                                        i++) ...[
                                      SpecializationTag(
                                        icon: mappedConsultTypes[
                                                current_consultTypes[i]] ??
                                            Icons.info_outline,
                                      )
                                    ]
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight / 100,
                                ),

                                // Attributes {rating, fav, wallet}
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 21,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                            '${cUserCtr.curr_rating.value}',
                                            // '4.3',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Jaldi'),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                            '${cUserCtr.curr_favCount.value}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Jaldi'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet,
                                          color: Color(0xff00a30b),
                                          size: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                            '${cUserCtr.curr_balance.value / 1000}k',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Jaldi'),
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
                      SizedBox(
                        height: 30,
                      ),
                      TabBar(
                          splashBorderRadius: BorderRadius.circular(20),
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 3,
                          indicatorColor: ThemeService().isSavedDarkMode()
                              ? kSecondary
                              : kPrimary,
                          controller: profileTabController,
                          tabs: [
                            Tab(
                              iconMargin: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.list_rounded,
                                color: Colors.amber,
                                size: 22,
                              ),
                              text: lang.isSavedLanguage() ? 'About' : "حول",
                            ),
                            Tab(
                              iconMargin: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.purple,
                                size: 22,
                              ),
                              text: lang.isSavedLanguage()
                                  ? 'Schedule'
                                  : "المواعيد",
                            ),
                            Tab(
                              iconMargin: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.blue,
                                size: 22,
                              ),
                              text: lang.isSavedLanguage()
                                  ? 'Reservations'
                                  : "الحجوزات",
                            )
                          ]),
                      Obx(() {
                        return SizedBox(
                          width: 100,
                          height: 400,
                          child: TabBarView(
                            controller: profileTabController,
                            children: [
                              //About
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 2, right: 2),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Material(
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(
                                          kCornerRoundness),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              ThemeService().isSavedDarkMode()
                                                  ? kPrimary
                                                  : kSecondary,
                                          borderRadius: BorderRadius.circular(
                                              kCornerRoundness),
                                        ),
                                        height: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    dragStartBehavior:
                                                        DragStartBehavior.down,
                                                    child: Text(
                                                      cUserCtr.curr_bio.value,
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
                                          borderRadius: BorderRadius.circular(
                                              kCornerRoundness)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 5),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.phone_iphone,
                                        ),
                                        title: Text(
                                          cUserCtr.curr_phone.value,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              kCornerRoundness)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 5),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.mail,
                                        ),
                                        title: Text(cUserCtr.curr_email.value,
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              kCornerRoundness)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 5),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.location_on_rounded,
                                        ),
                                        title:
                                            Text(cUserCtr.curr_location.value,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Schedule
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 1, right: 1),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: ToggleButtons(
                                        constraints: BoxConstraints(
                                            minWidth: 45, minHeight: 35),
                                        selectedColor: Colors.amber,
                                        fillColor:
                                            Color.fromARGB(70, 198, 26, 255),
                                        borderRadius: BorderRadius.circular(
                                            kCornerRoundness - 10),
                                        isSelected: mainCtr.AvailableDays,
                                        onPressed: (int index) {
                                          setState(() {
                                            mainCtr.AvailableDays[index] =
                                                !mainCtr.AvailableDays[index];
                                          });
                                        },
                                        children: weekDays,
                                      ),
                                    ),

                                    // time 1
                                    Text(
                                      lang.isSavedLanguage()
                                          ? "First Period"
                                          : "التوقيت الأول",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          lang.isSavedLanguage()
                                              ? "From:"
                                              : "من",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: TextButton(
                                            onPressed: () async {
                                              TimeOfDay? newTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: 12, minute: 10),
                                              );

                                              setState(() {
                                                mainCtr.t1start.value =
                                                    newTime ??
                                                        mainCtr.t1start.value;
                                              });
                                            },
                                            child: Text(
                                              mainCtr.t1start.value.hour
                                                  .toString(),
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          lang.isSavedLanguage()
                                              ? "To:"
                                              : "إلى",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: TextButton(
                                            onPressed: () async {
                                              TimeOfDay? newTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: 12, minute: 10),
                                              );

                                              setState(() {
                                                mainCtr.t1end.value = newTime ??
                                                    mainCtr.t1end.value;
                                              });
                                            },
                                            child: Text(
                                              mainCtr.t1end.value.hour
                                                  .toString(),
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(
                                        height: 20,
                                        color: Colors.purple,
                                        indent: 40,
                                        endIndent: 40,
                                      ),
                                    ),

                                    // time 2
                                    Text(
                                      lang.isSavedLanguage()
                                          ? "Second Period"
                                          : "التوقيت الثاني",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          lang.isSavedLanguage()
                                              ? "From:"
                                              : "من",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: TextButton(
                                            onPressed: () async {
                                              TimeOfDay? newTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: 12, minute: 10),
                                              );

                                              setState(() {
                                                mainCtr.t2start.value =
                                                    newTime ??
                                                        mainCtr.t2start.value;
                                              });
                                            },
                                            child: Text(
                                              mainCtr.t2start.value.hour
                                                  .toString(),
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          lang.isSavedLanguage()
                                              ? "To:"
                                              : "إلى",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: TextButton(
                                            onPressed: () async {
                                              TimeOfDay? newTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: 12, minute: 10),
                                              );

                                              setState(() {
                                                mainCtr.t2end.value = newTime ??
                                                    mainCtr.t2end.value;
                                              });
                                            },
                                            child: Text(
                                              mainCtr.t2end.value.hour
                                                  .toString(),
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          var response = json.decode(
                                              await routes.updateSchedule(
                                                  current_id,
                                                  mainCtr.t1start.value.hour,
                                                  mainCtr.t2start.value.hour,
                                                  mainCtr.t1end.value.hour,
                                                  mainCtr.t2end.value.hour,
                                                  mainCtr.AvailableDays));

                                          // print(response['message']);

                                          if (response['success'] == true) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 40,
                                                  ),
                                                  content: Text(
                                                    lang.isSavedLanguage()
                                                        ? "Your Schedule has been updated"
                                                        : "تم التعديل على المواعيد",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          lang.isSavedLanguage()
                                                              ? 'Ok'
                                                              : "حسناً",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontFamily: 'Jaldi',
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Icon(
                                                    Icons
                                                        .error_outline_outlined,
                                                    color: Colors.redAccent,
                                                    size: 40,
                                                  ),
                                                  content: Text(
                                                    lang.isSavedLanguage()
                                                        ? "an error has occurred"
                                                        : "حدث خطأ ما",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          lang.isSavedLanguage()
                                                              ? 'Ok'
                                                              : "حسناً",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontFamily: 'Jaldi',
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Text(
                                          lang.isSavedLanguage()
                                              ? "Update"
                                              : "تحديث",
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ))
                                  ],
                                ),
                              ),
                              //TODO: Implement Reservations
                              Column(
                                children: expert.appointments,
                              ),
                            ],
                          ),
                        );
                      }),
                    ] else ...[
                      // Name, specs , attributes
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Name
                          Text(
                            cUserCtr.curr_name.value,
                            style: TextStyle(fontSize: 45),
                          ),
                          SizedBox(
                            height: screenHeight / 100,
                          ),

                          // Attributes (wallet)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: Color(0xff00a30b),
                                size: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  '${cUserCtr.curr_balance.value / 1000}k',
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: screenHeight / 15,
                          ),

                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kCornerRoundness)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 5),
                            child: ListTile(
                              leading: Icon(
                                Icons.phone_iphone,
                              ),
                              title: Text(
                                cUserCtr.curr_phone.value,
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 5),
                            child: ListTile(
                              leading: Icon(
                                Icons.mail,
                              ),
                              title: Text(cUserCtr.curr_email.value,
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],

                    Container(height: 10)
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/*
* Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kCornerRoundness)),
                    margin: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: DropdownButton<int>(
                                value: t1h1,
                                //isExpanded: true,
                                iconSize: 16,
                                icon: Icon(Icons.language),
                                itemHeight: 48,

                                underline: Divider(
                                  color: Colors.purpleAccent,
                                  height: 2,
                                ),

                                items: <int>[
                                  1,
                                  2,
                                  3,
                                  4,
                                  5,
                                  6,
                                  7,
                                  8,
                                  9,
                                  10,
                                  11,
                                  12,
                                  13,
                                  14,
                                  15,
                                  16,
                                  17,
                                  18,
                                  19,
                                  20,
                                  21,
                                  22,
                                  23,
                                  24,
                                ].map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      '$value',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  );
                                }).toList(),

                                onChanged: (int? newValue) {
                                  t1h1 = newValue!;
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_outlined,
                                size: 20,
                              )),
                          Expanded(
                              flex: 2,
                              child: DropdownButton<String>(
                                value: selectedLanguage,
                                //isExpanded: true,
                                iconSize: 16,
                                icon: Icon(Icons.language),
                                itemHeight: 48,

                                underline: Divider(
                                  color: Colors.purpleAccent,
                                  height: 2,
                                ),

                                items: <String>[
                                  'English',
                                  'Arabic'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  );
                                }).toList(),

                                onChanged: (String? newValue) {
                                  selectedLanguage = newValue!;
                                },
                              ))
                        ],
                      ),
                    ),
                  ),*/

//slider for changing the schedule of the expert
/*
* SfSlider(
                    min: 1,
                    max: 12.0,
                    value: t1h1.toInt(),
                    interval: 1,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,

                    onChanged: (value) {
                      setState(() {
                        t1h1 = value;
                        int a = t1h1.floor() ;
                        print(a);
                      });
                    },
                  ),*/

class SpecializationTag extends StatelessWidget {
  SpecializationTag(
      {Key? key, this.name = '', this.icon = Icons.info, this.tagWidth = 115})
      : super(key: key);
  final String name;
  final IconData icon;
  final double tagWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeService().isSavedDarkMode() ? kPrimary : kSecondary,
        borderRadius: BorderRadius.circular(kCornerRoundness),
        border: Border.all(
          width: 0.3,
          color: ThemeService().isSavedDarkMode() ? kSecondary : kPrimary,
        ),
      ),
      height: 35,
      width: name.length * 6 + 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
        ],
      ),
    );
  }
}
