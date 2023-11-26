import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/screens/components/drawer_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(appPadding),
            child: Image.asset("images/app_icon.png", height: 100, width: 100),
          ),
          DrawerListTile(
              title: 'Dashboard',
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {}),
          DrawerListTile(
              title: 'Kelola Materi',
              svgSrc: 'assets/icons/BlogPost.svg',
              tap: () {}),
          DrawerListTile(
              title: 'Kelola Kuis', svgSrc: 'assets/icons/Message.svg', tap: () {}),
          // DrawerListTile(
          //     title: 'Statistics',
          //     svgSrc: 'assets/icons/Statistics.svg',
          //     tap: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          // DrawerListTile(
          //     title: 'Settings',
          //     svgSrc: 'assets/icons/Setting.svg',
          //     tap: () {}),
          DrawerListTile(
            title: 'Logout',
            svgSrc: 'assets/icons/Logout.svg',
            tap: () async {
              FirebaseAuth.instance.signOut();
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.remove('userId');
              prefs.remove('username');
              Navigator.pushNamed(
              context, "/landingPage");
              },
          ),
        ],
      ),
    );
  }
}
