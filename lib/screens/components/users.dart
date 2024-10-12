import 'package:algopintar/screens/components/students_table.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

import 'bar_chart_users.dart';

class Users extends StatelessWidget {
  final List<Map<dynamic, dynamic>> students;
  final int materiCount;
  const Users({Key? key, required this.students, required this.materiCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Data Siswa",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textColor,
            ),
          ),
          Expanded(
            child: StudentsTable(students: students, materiCount: materiCount,),
          )
        ],
      ),
    );
  }
}
