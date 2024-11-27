import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

class HistoryScoringDetail extends StatelessWidget {
  final String namaUser;
  final String namaMateri;
  final int skor;
  final int timeLearn;

  const HistoryScoringDetail({
    Key? key,
    required this.namaUser,
    required this.namaMateri,
    required this.skor,
    required this.timeLearn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return SizedBox();
    return Container(
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama User
                Text(
                  namaUser,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                // Nama Materi
                Text(
                  namaMateri,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Skor dan TimeLearn
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Skor: $skor",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Time: ${timeLearn ~/ 60} min ${timeLearn % 60} sec",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: textColor.withOpacity(0.7),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
