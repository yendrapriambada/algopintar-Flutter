import 'package:algopintar/screens/components/pertemuan.dart';
import 'package:algopintar/screens/components/quiz_pertemuan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/screens/components/custom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/mata_pelajaran_model.dart';


class ManageQuizContent extends StatefulWidget {
  const ManageQuizContent({Key? key}) : super(key: key);

  @override
  State<ManageQuizContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<ManageQuizContent> {
  late DatabaseReference _pertemuanRef;
  List<PertemuanModel> _pertemuan = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Firebase.initializeApp();
    _pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan');

    _pertemuanRef.onChildRemoved.listen((event) {
      _pertemuan.clear();
      setState(() {}); // Trigger widget rebuild after updating data
    });

    _pertemuanRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("data ada");
        Map<String, dynamic> pertemuanMap = event.snapshot.value as Map<String, dynamic>;
        _updatePertemuanList(pertemuanMap);
      }
    });
  }

  void _updatePertemuanList(Map<String, dynamic> pertemuanMap) {
    _pertemuan.clear();
    pertemuanMap.forEach((key, value) {
      Map<String, dynamic> pertemuanData = value as Map<String, dynamic>;
      PertemuanModel pertemuan = PertemuanModel.fromJson(pertemuanData, key);
      _pertemuan.add(pertemuan);
    });
    _pertemuan.sort((a, b) => a.namaPertemuan.compareTo(b.namaPertemuan));

    print("Lenght: ${_pertemuan.length}");
    setState(() {}); // Trigger widget rebuild after updating data
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(pageName: "Kelola Quiz",),
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
                          QuizPertemuan(pertemuan: _pertemuan),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}