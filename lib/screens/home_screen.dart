// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:excon/components/custom_text_field.dart';
import 'package:excon/components/theme_service.dart';
import 'package:excon/connection/Routes.dart';
import 'package:excon/connection/db.dart';
import 'package:excon/constants.dart';
import 'package:excon/main.dart';
import 'package:excon/screens/chats_screen.dart';
import 'package:excon/screens/favorites_screen.dart';
import 'package:excon/screens/profile_screen.dart';
import 'package:excon/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../components/bottom_bar.dart';
import '../components/expert_card.dart';
import '../components/gradient_button.dart';
import 'show_profile.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int tab = 2;
  bool isLoading = true;
  bool show = true;
  bool showSearch = false;
  bool _isVisible = true;
  double bottomBarSize = 60;
  late ScrollController _hideButtonController;
  late TabController tabController;
  late Routes routes = Routes();
  Map info = {'name': '', 'rating': ''};
  Expert expertCtr = Get.put(Expert());
  List<Map> credentials = [];
  List<Widget> expertWidgets = [];

  // DarkThemeProvider themeDataProvider = DarkThemeProvider();
  // void getCurrentAppTheme() async {
  //   themeDataProvider.darkTheme =
  //       await themeDataProvider.darkThemePreference.getTheme();
  // }

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    expertCtr.fetch();

    tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: 2,
    );
    _isVisible = true;
    _hideButtonController = ScrollController();

    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
              ScrollDirection.reverse ||
          _hideButtonController.position.atEdge) {
        setState(() {
          _isVisible = false;
          if (bottomBarSize > 0) {
            bottomBarSize--;
          }
        });
      }

      if (_hideButtonController.position.userScrollDirection ==
              ScrollDirection.forward ||
          _hideButtonController.position.atEdge) {
        setState(() {
          if (bottomBarSize < 60) {
            bottomBarSize += 1;
          }
          _isVisible = true;
        });
        if (_hideButtonController.position.atEdge &&
            _hideButtonController.position.pixels < 100) {
          bottomBarSize = 60;
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    _hideButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: TabBarView(controller: tabController, children: [
          SettingsScreen(),
          ProfileScreen(),
          CustomScrollView(
            controller: _hideButtonController,
            clipBehavior: Clip.antiAlias,
            slivers: [
              SliverAppBar(
                shadowColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
                surfaceTintColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
                foregroundColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,
                backgroundColor: ThemeService().isSavedDarkMode()? kPrimary:kSecondary,

                automaticallyImplyLeading: false,
                toolbarHeight: 80,
                expandedHeight: bottomBarSize * 2,
                primary: true,
                pinned: true,
                floating: true,
                snap: true,
                forceElevated: true,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(kCornerRoundness),
                    bottomRight: Radius.circular(kCornerRoundness),
                  ),
                ),
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 32,
                      child: Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: bottomBarSize * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang.isSavedLanguage() ? 'Explore' : "الرئيسية",
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                          if (!showSearch) ...[
                            IconButton(
                              iconSize:
                                  bottomBarSize <= 60 ? bottomBarSize / 2 : 30,
                              onPressed: () {
                                setState(() {
                                  showSearch = true;
                                });
                              },
                              icon: Icon(
                                Icons.search_outlined,
                                color: ThemeService().isSavedDarkMode()? kSecondary:kPrimary,
                              ),
                            ),
                          ] else if (showSearch && bottomBarSize != 0) ...[
                            SizedBox(
                              width: 200,
                              height: 45,
                              child: CustomTextField(
                                hintText:
                                    lang.isSavedLanguage() ? 'Search' : "بحث",
                                hintTextColor: kPrimary,
                                onChanged: (value) {
                                  expertCtr.fetchAfterSearch(value);
                                  if (value == "") {
                                    expertCtr.fetch();
                                  }
                                },
                                onSubmitted: () {
                                  setState(() {
                                    showSearch = !showSearch;
                                  });
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 32,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (show) ...[
                              Cat_GradientButton(
                                  onPressed: () {
                                    setState(() {
                                      expertCtr.fetchAfterSearch("",
                                          consultType: "tech");
                                    });
                                  },
                                  text: lang.isSavedLanguage()
                                      ? 'Technical'
                                      : "تقنية"),
                              Cat_GradientButton(
                                  onPressed: () {
                                    setState(() {
                                      expertCtr.fetchAfterSearch("",
                                          consultType: "legal");
                                    });
                                  },
                                  text: lang.isSavedLanguage()
                                      ? 'Legal'
                                      : "قانونية"),
                              Cat_GradientButton(
                                  onPressed: () {
                                    setState(() {
                                      expertCtr.fetchAfterSearch("",
                                          consultType: "medical");
                                    });
                                  },
                                  text: lang.isSavedLanguage()
                                      ? 'Medical'
                                      : "طبية"),
                              Cat_GradientButton(
                                  onPressed: () {
                                    setState(() {
                                      expertCtr.fetchAfterSearch("",
                                          consultType: "vocational");
                                    });
                                  },
                                  text: lang.isSavedLanguage()
                                      ? 'Vocational'
                                      : "مهنية"),
                            ] else ...[
                              GradientButton(
                                minWidth: 40,
                                minHeight: 30,
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(
                                    colors: [Colors.amber, Colors.purple],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                child: Icon(
                                  Icons.list,
                                  // color: kSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    show = !show;
                                  });
                                },
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading) ...[
                SliverToBoxAdapter(
                  child: Container(
                    height: 500,
                    width: 500,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                      semanticsLabel: 'Fetching',
                    )),
                  ),
                )
              ] else ...[
                Obx(() {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          title: expertCtr.expertWidgets[index]),
                      childCount: expertCtr.expertWidgets.length,
                    ),
                  );
                })
              ],
              SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          ChatsScreen(),
          FavoritesScreen()
        ],),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isVisible
            ? FloatingActionButton(
                elevation: 5,
                shape: CircleBorder(),
                // backgroundColor: kPrimary,
                child: Image.asset(
                  'images/logo.png',
                  cacheWidth: 100,
                  cacheHeight: 100,
                  scale: 2.5,
                ),
                onPressed: () {
                  //credentials.clear();
                  //ExpertWidgets.clear();
                  setState(() {
                    showSearch = false;
                    expertCtr.fetch();
                  });
                },
              )
            : null,
        bottomNavigationBar: AnimatedContainer(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,

          curve: Curves.decelerate,
          duration: Duration(milliseconds: 300),
          height: _isVisible ? 65 : 0,
          child: BottomBar(
            controller: tabController,
          ),
        ),
      ),
    );
  }
}

class Cat_GradientButton extends StatelessWidget {
  Cat_GradientButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      minWidth: 80,
      minHeight: 40,
      strokeWidth: 2,
      radius: 40,
      gradient: LinearGradient(
          colors: [Colors.amber, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      onPressed: onPressed,
      child: Text(text,
          style: TextStyle(
            fontFamily: 'Jaldi',
            fontSize: 14,
            // color: kSecondary,
          )),
    );
  }
}

class ExpertInstance extends StatelessWidget {
  ExpertInstance({required this.information});

  Map information = {
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
  };

  @override
  Widget build(BuildContext context) {
    return ExpertCard(
      expert_name: information['name'],
      rating: information['rating'],
      consultTypes: information['consultations'],
      photo_path: information['photo_path'] ?? "noImage",
      onPressed: () {
        //print(information['id']);
        mainCtr.pressedID.value = information['id'];
        // print(mainCtr.pressedID);

        showModalBottomSheet(
          elevation: 1,
          isScrollControlled: true,
          //anchorPoint: Offset(10, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          context: context,
          builder: (context) => ShowProfile(
            context,
            name: information['name'],
            balance: information['balance'],
            favCount: information['fav'],
            rating: information['rating'],
            location: information['location'],
            email: information['email'],
            phone: information['phone'],
            bio: information['bio'],
            id: information['id'],
            serviceCost: information['service_cost'],
            consultations: information['consultations'],
            photo_path: information['photo_path'] ?? "noImage",
          ),
        );
      },
    );
  }
}
//TODO: Implement Lazy Loading
// bottom navigation bar
/*
BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    tab = value;
                  });
                },

                type: BottomNavigationBarType.fixed,
                currentIndex: tab,
                items: [
                  BottomNavigationBarItem(
                    label: 'Explore',
                    icon: Icon(Icons.radar),
                    activeIcon: Icon(Icons.radar_rounded),
                  ),
                  BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(Icons.person),
                    activeIcon: Icon(Icons.person_outline),
                  ),
                  BottomNavigationBarItem(
                    label: 'Settings',
                    icon: Icon(Icons.settings),
                    activeIcon: Icon(Icons.settings),
                  ),
                ],
              ),
*/
// former app bar
/*
* FloatingActionButton(
                          onPressed: () {},
                          mini: true,
                          backgroundColor: kPrimary,
                          child: Icon(
                            Icons.filter_alt_outlined,
                            color: kSecondary,
                          ),
                        ),
                        Container(
                          width: 310,
                          child: CustomTextField(
                            hintText: 'Search',
                            borderColor: kSecondary,
                            hintTextColor: kSecondary,
                            onChanged: (value) {
                              print(value);
                            },
                            onTap: () {},
                          ),
                        ),*/

/*
BottomBar(
color: kPrimary,
),
 */

/*
* SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: ExpertCard(
                              expert_name: 'Expert',
                              icon: Icon(
                                Icons.medical_services,
                                color: kPrimary,
                                size: 20,
                              ),
                              rate: 4.5,
                              // textColor: kSecondary,
                              // borderColor: kSecondary,
                            )),
                        childCount: 12,
                      ),
                    ),*/
// working
/*
*
*  SliverToBoxAdapter(
                      child: Container(
                        height: 10,
                        child: FutureBuilder<List>(
                          future: expert.getAllExperts(),
                          builder: (context, snapshot) {
                            print(snapshot.error);
                            if (snapshot.hasData) {
                              length = snapshot.data!.length;

                              ///print(snapshot.data);
                              for (int i = 0; i < snapshot.data!.length; i++) {
                                //List<Map> a=jsonDecode(snapshot.data![i]['user']);
                                var a = snapshot.data![i]['user'];
                                info = {
                                  'name': a['full_name_en'],
                                  'rating': snapshot.data![i]['rating'] + 0.0,
                                };
                                credentials.add(info);
                                ExpertWidgets.add(
                                  ExpertInstance(
                                    infor: info,
                                  ),
                                );
                                print(credentials[i].values.elementAt(0));
                              }
                              return Container(
                                height: 0,
                              );
                            } else {
                              return Container(
                                height: 0,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: ExpertWidgets[index]),
                        childCount: length,
                      ),
                    ),
* */

// SliverToBoxAdapter(
//   child: Container(
//     height: 100,
//     child: FutureBuilder<List>(
//       future: bruh,
//       builder: (context, snapshot) {
//         print(snapshot.error);
//         if (snapshot.hasData) {
//           ///print(snapshot.data);
//           for (int i = 0; i < snapshot.data!.length; i++) {
//             //List<Map> a=jsonDecode(snapshot.data![i]['user']);
//             var a = snapshot.data![i]['user'];
//             info = {
//               'name': a['full_name_en'],
//               'rating': snapshot.data![i]['rating'] + 0.0,
//             };
//             length = snapshot.data!.length;
//             credentials.add(info);
//             ExpertWidgets.add(
//               ExpertInstance(
//                 infor: info,
//               ),
//             );
//             print(credentials[i].values.elementAt(0));
//           }
//           return ListView.builder(
//             controller: _hideButtonController,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                 title: ExpertWidgets[index],
//               );
//             },
//             itemCount: length,
//           );
//         } else {
//           return Container(
//             width: 50,
//             height: 50,
//             child: CircularProgressIndicator(
//               color: Colors.amber,
//             ),
//           );
//         }
//       },
//     ),
//   ),
// ),
//
