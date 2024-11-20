import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

import 'leaderboard_info_detail.dart';

class Leaderboard extends StatelessWidget {
  final List<Map<dynamic, dynamic>> students;
  const Leaderboard({Key? key, required this.students, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    students.sort((a, b) => b['score'].compareTo(a['score']));

    // Ambil 5 besar siswa
    final top5Students = students.take(5).toList();

    // Get current user info from Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserEmail = currentUser?.email;

    // Find current user's rank and data
    final userIndex = students.indexWhere((student) => student['email'] == currentUserEmail);
    final currentUserData = userIndex >= 0 ? students[userIndex] : null;
    final currentUserRank = userIndex + 1;


    return Container(
      height: 100,
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
          // Tampilkan 5 besar leaderboard
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: top5Students.length,
                itemBuilder: (context, index) {
                  final student = top5Students[index];
                  return LeaderboardInfoDetail(student: student, rank: index + 1);
                },
              ),
            // Expanded(
            //   child: ListView.builder(
            //     physics: NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: students.length,
            //     itemBuilder: (context, index) => LeaderboardInfoDetail(student: students[index],),
            //   ),
            ),
          ),
          const Divider(color: Colors.grey),

          // Display current user if outside top 5
          if (currentUserRank > 5 && currentUserData != null)
            LeaderboardInfoDetail(
              student: currentUserData,
              rank: currentUserRank,
            ),

          // Display a message if current user is not found
          if (currentUserData == null)
            const Text(
              'Your data is not available in the leaderboard.',
              style: TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
