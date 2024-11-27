import 'package:algopintar/screens/history_scoring_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';


class HistoryScoring extends StatefulWidget {
  const HistoryScoring({Key? key, }) : super(key: key);

  @override
  State<HistoryScoring> createState() => _HistoryScoringState();
}

class _HistoryScoringState extends State<HistoryScoring> {
  final DatabaseReference _historyRef =
  FirebaseDatabase.instance.ref("historyScoring"); // Referensi Firebase
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  String _filterName = ""; // Filter berdasarkan namaUser

  @override
  void initState() {
    super.initState();
    _loadHistoryScoring();
  }

  Future<void> _loadHistoryScoring() async {
    final snapshot = await _historyRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      final historyList = data.entries.map((entry) {
        final value = entry.value as Map<dynamic, dynamic>;
        return {
          "id": entry.key,
          "idUser": value['idUser'] ?? "",
          "namaMateri": value['namaMateri'] ?? "",
          "namaUser": value['namaUser'] ?? "Unknown",
          "skor": value['skor'] ?? 0,
          "timeLearn": value['timeLearn'] ?? 0,
        };
      }).toList();

      setState(() {
        _students = historyList;
        _filteredStudents = historyList;
      });
    }
  }

  void _filterStudents(String name) {
    setState(() {
      _filterName = name;
      if (_filterName.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students
            .where((student) =>
            student['namaUser'].toLowerCase().contains(_filterName.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 600,
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
                'History Scoring',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          // Search Filter
          TextField(
            onChanged: (value) => _filterStudents(value),
            decoration: InputDecoration(
              hintText: "Search by user name...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: _filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = _filteredStudents[index];
                  return HistoryScoringDetail(
                    namaUser: student['namaUser'],
                    namaMateri: student['namaMateri'],
                    skor: student['skor'],
                    timeLearn: student['timeLearn'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
