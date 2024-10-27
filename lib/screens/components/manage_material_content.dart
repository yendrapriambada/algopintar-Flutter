import 'package:algopintar/screens/components/materi_pertemuan_table.dart';
import 'package:algopintar/screens/components/pertemuan.dart';
import 'package:algopintar/screens/components/pertemuan_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/screens/components/custom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/mata_pelajaran_model.dart';


class ManageMaterialContent extends StatefulWidget {
  const ManageMaterialContent({Key? key}) : super(key: key);

  @override
  State<ManageMaterialContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<ManageMaterialContent> {
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
            CustomAppbar(pageName: "Kelola Materi",),
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
                          Container(
                            height: 600,
                            width: double.infinity,
                            padding: EdgeInsets.all(appPadding),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [MateriPertemuanTable(pertemuan: _pertemuan)],
                            ),
                          ),
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