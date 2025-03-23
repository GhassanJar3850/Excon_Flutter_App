// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/theme_service.dart';
import '../connection/db.dart';
import '../constants.dart';
import '../main.dart';

class FavoritesScreen extends StatefulWidget {
  static String id = 'favorites_screen';

  FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Expert expertCtr = Get.put(Expert());

  @override
  void initState() {
    expertCtr.fetchFavorites(current_id);
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
              ),
            ),
            title: Text(
              lang.isSavedLanguage() ? 'Favorites' : "المفضلة",
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
                    title: expertCtr.favExpertWidgets[expertCtr.favExpertWidgets.length-index-1]),
                childCount: expertCtr.favExpertWidgets.length,
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
