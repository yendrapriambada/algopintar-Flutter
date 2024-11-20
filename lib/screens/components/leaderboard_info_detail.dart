import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

class LeaderboardInfoDetail extends StatelessWidget {
  final Map<dynamic, dynamic> student;
  final int rank;
  const LeaderboardInfoDetail({Key? key, required this.student, required this.rank,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: appPadding),
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
          // Tampilkan angka ranking
          Text(
            '$rank',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              'https://api.dicebear.com/7.x/adventurer/png?seed='+ student['username']+'&backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf',
              height: 38,
              width: 38,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['fullName'],
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  //
                  // Text(
                  //   info.date!,
                  //   style: TextStyle(
                  //       color: textColor.withOpacity(0.5),
                  //     fontSize: 13,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Icon(Icons.more_vert_rounded,color: textColor.withOpacity(0.5),size: 18,)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              student['score'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
