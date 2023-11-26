import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/constants/responsive.dart';
import 'package:algopintar/screens/components/analytic_cards.dart';
import 'package:algopintar/screens/components/custom_appbar.dart';
import 'package:algopintar/screens/components/top_referals.dart';
import 'package:algopintar/screens/components/users.dart';
import 'package:algopintar/screens/components/users_by_device.dart';
import 'package:algopintar/screens/components/viewers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'leaderboard.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  late DatabaseReference _studentsRef;
  List<Map<dynamic, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Firebase.initializeApp();
    _studentsRef = FirebaseDatabase.instance.ref().child('users');

    _studentsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> studentsMap = event.snapshot.value as Map<dynamic, dynamic>;
        _updateStudentsList(studentsMap);
      }
    });
  }

  void _updateStudentsList(Map<dynamic, dynamic> studentsMap) {
    _students.clear();
    studentsMap.forEach((key, value) {
      if (value['role'] == 'student') {
        _students.add(value);
      }
    });
    setState(() {}); // Trigger widget rebuild after updating data
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          AnalyticCards(studentCount: _students.length,),
                          SizedBox(
                            height: appPadding,
                          ),
                          Users(students: _students,),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) Leaderboard(students: _students,),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: Leaderboard(students: _students,),
                      ),
                  ],
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       flex: 5,
                //       child: Column(
                //         children: [
                //           SizedBox(
                //             height: appPadding,
                //           ),
                //           Row(
                //             children: [
                //               if(!Responsive.isMobile(context))
                //                 Expanded(
                //                   child: TopReferals(),
                //                   flex: 2,
                //                 ),
                //               if(!Responsive.isMobile(context))
                //                 SizedBox(width: appPadding,),
                //               Expanded(
                //                 flex: 3,
                //                 child: Viewers(),
                //               ),
                //             ],
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //           ),
                //           SizedBox(
                //             height: appPadding,
                //           ),
                //           if (Responsive.isMobile(context))
                //             SizedBox(
                //               height: appPadding,
                //             ),
                //           if (Responsive.isMobile(context)) TopReferals(),
                //           if (Responsive.isMobile(context))
                //             SizedBox(
                //               height: appPadding,
                //             ),
                //           if (Responsive.isMobile(context)) UsersByDevice(),
                //         ],
                //       ),
                //     ),
                //     if (!Responsive.isMobile(context))
                //       SizedBox(
                //         width: appPadding,
                //       ),
                //     if (!Responsive.isMobile(context))
                //       Expanded(
                //         flex: 2,
                //         child: UsersByDevice(),
                //       ),
                //   ],
                // ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
