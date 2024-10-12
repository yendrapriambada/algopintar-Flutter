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
  late DatabaseReference _pertemuanRef;
  late DatabaseReference _materiRef;
  List<Map<dynamic, dynamic>> _students = [];
  List<Map<dynamic, dynamic>> _guru = [];
  List<Map<dynamic, dynamic>> _pertemuan = [];
  List<Map<dynamic, dynamic>> _materi = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Firebase.initializeApp();
    _studentsRef = FirebaseDatabase.instance.ref().child('users');
    _pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan');
    _materiRef = FirebaseDatabase.instance.ref().child('materialList');

    _studentsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> studentsMap = event.snapshot.value as Map<dynamic, dynamic>;
        _updateStudentsList(studentsMap);
      }
    });

    _pertemuanRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> pertemuanMap = event.snapshot.value as Map<dynamic, dynamic>;
        _updatePertemuanList(pertemuanMap);
      }
    });

    _materiRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> materiMap = event.snapshot.value as Map<dynamic, dynamic>;
        _updateMateriList(materiMap);
      }
    });
  }

  void _updateStudentsList(Map<dynamic, dynamic> studentsMap) {
    _students.clear();
    _guru.clear();
    studentsMap.forEach((key, value) {
      if (value['role'] == 'student') {
        _students.add(value);
      }
      else if (value['role'] == 'teacher') {
        _guru.add(value);
      }
    });
    setState(() {}); // Trigger widget rebuild after updating data
  }

  void _updatePertemuanList(Map<dynamic, dynamic> pertemuanMap) {
    _pertemuan.clear();
    pertemuanMap.forEach((key, value) {
        _pertemuan.add(value);
    });
    setState(() {}); // Trigger widget rebuild after updating data
  }

  void _updateMateriList(Map<dynamic, dynamic> materiMap) {
    _materi.clear();
    materiMap.forEach((key, value) {
      _materi.add(value);
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
            CustomAppbar(pageName: "Dashboard Guru",),
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
                          AnalyticCards(studentCount: _students.length, guruCount: _guru.length, pertemuanCount: _pertemuan.length, materiCount: _materi.length,),
                          SizedBox(
                            height: appPadding,
                          ),
                          Users(students: _students, materiCount: _materi.length),
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
