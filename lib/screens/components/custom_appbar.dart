import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/constants/responsive.dart';
import 'package:algopintar/controllers/controller.dart';
import 'package:algopintar/screens/components/profile_info.dart';
import 'package:algopintar/screens/components/search_field.dart';
import 'package:provider/provider.dart';

import '../landing_page_screen.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({Key? key, required this.pageName}) : super(key: key);

  final String pageName;
  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String username = 'Bapak/Ibu Guru';

  @override
  void initState() {
    super.initState();
    getCurrentUsername();
  }

  Future<void> getCurrentUsername() async {
    User? user = _auth.currentUser;

    if (user?.uid != null) {
      final snapshot = await _database.child('users/${user?.uid}').get();
      if (snapshot.exists) {
        var userMap = snapshot.value as Map<dynamic, dynamic>?;
        var usernameValue = userMap?['username'] as String?;

        if (usernameValue != null) {
          setState(() {
            username = usernameValue;
          });
        }
      } else {
        print('No data available.');
      }
    } else {
      const LandingPage();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: context.read<Controller>().controlMenu,
            icon: Icon(Icons.menu,color: textColor.withOpacity(0.5),),
          ),
        // Expanded(child: SearchField()),
        SizedBox(width: appPadding,),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Text(
                widget.pageName,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
        ),
        ProfileInfo(username: username),
      ],
    );
  }
}
