import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

import 'leaderboard_info_detail.dart';

class Leaderboard extends StatelessWidget {
  final List<Map<dynamic, dynamic>> students;
  const Leaderboard({Key? key, required this.students}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    students.sort((a, b) => b['score'].compareTo(a['score']));
    return Container(
      height: 540,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Papan Peringkat',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // Text(
              //   'View All',
              //   style: TextStyle(
              //     color: textColor.withOpacity(0.5),
              //     fontWeight: FontWeight.bold,
              //     fontSize: 13,
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 2.0,
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (context, index) => LeaderboardInfoDetail(student: students[index],),
            ),
          )
        ],
      ),
    );
  }
}
