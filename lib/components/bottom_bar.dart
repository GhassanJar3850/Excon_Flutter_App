// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, sort_child_properties_last

import 'package:excon/components/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key, required this.controller})
      : super(key: key);

  final TabController controller;

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      elevation: 10,
      notchMargin: 9,
      shape: CircularNotchedRectangle(),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(kCornerRoundness),
              topLeft: Radius.circular(kCornerRoundness)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.amber,
              Colors.purple,
            ],
          ),
        ),
        child: TabBar(
          // indicatorColor: kPrimary,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3,
          labelColor: !ThemeService().isSavedDarkMode() ? kPrimary : kSecondary,
          controller: widget.controller,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.settings,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.person,
                size: 25,
              ),
            ),
            SizedBox(
              width: 20,
              height: 60,
            ),
            Tab(
              icon: Icon(
                Icons.chat_bubble,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.favorite,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.teal,
            Colors.purple,
          ],
        )),
    child: TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.white,

      tabs: [
        Tab(
          text: "Explore",
          icon: Icon(Icons.compass_calibration_rounded),

        ),
        Tab(
          text: "Profile",
          icon: Icon(Icons.person),
        ),
        Tab(
          text: "Settings",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
*/

/*
*  new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                color: kSecondary,
                iconSize: 25,
                onPressed: () {
                  setState(() {
                    kLightSwitch();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                color: kSecondary,
                iconSize: 25,
                onPressed: () {
                  setState(() {});
                },
              ),
              SizedBox(
                width: 20,
                height: 60,
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble),
                color: kSecondary,
                iconSize: 25,
                onPressed: () {
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                color: kSecondary,
                iconSize: 25,
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),*/
