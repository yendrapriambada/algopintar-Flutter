import 'package:algopintar/screens/components/pertemuan.dart';
import 'package:algopintar/screens/components/pertemuan_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/screens/components/custom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/mata_pelajaran_model.dart';

class ManagePertemuanContent extends StatefulWidget {
  const ManagePertemuanContent({Key? key}) : super(key: key);

  @override
  State<ManagePertemuanContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<ManagePertemuanContent> {
  late DatabaseReference _pertemuanRef;
  List<PertemuanModel> _pertemuan = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    // Inisialisasi Firebase
    await Firebase.initializeApp();
    _pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan');

    // Listener untuk data yang dihapus
    _pertemuanRef.onChildRemoved.listen((event) {
      _pertemuan.clear();
      setState(() {}); // Trigger widget rebuild setelah data diubah
    });

    // Listener untuk data yang diupdate
    _pertemuanRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("Data ada: ${event.snapshot.value.runtimeType}");
        // Validasi tipe data sebelum di-cast
        if (event.snapshot.value is Map<Object?, Object?>) {
          // Konversi tipe data ke Map<String, dynamic>
          Map<String, dynamic> pertemuanMap = (event.snapshot.value as Map)
              .map((key, value) => MapEntry(key.toString(), value));

          _updatePertemuanList(pertemuanMap);
        } else {
          print("Tipe data tidak sesuai: ${event.snapshot.value.runtimeType}");
        }
      } else {
        print("Tidak ada data");
      }
    });
  }

  void _updatePertemuanList(Map<String, dynamic> pertemuanMap) {
    _pertemuan.clear();

    // Iterasi data untuk memproses setiap item
    pertemuanMap.forEach((key, value) {
      if (value is Map) {
        // Validasi tipe data sebelum parsing
        Map<String, dynamic> pertemuanData =
        value.map((k, v) => MapEntry(k.toString(), v));
        try {
          PertemuanModel pertemuan =
          PertemuanModel.fromJson(pertemuanData, key);
          _pertemuan.add(pertemuan);
        } catch (e) {
          print("Error parsing data untuk key $key: $e");
        }
      } else {
        print("Data dengan key $key tidak valid: ${value.runtimeType}");
      }
    });

    // Sorting daftar pertemuan
    _pertemuan.sort((a, b) => a.namaPertemuan.compareTo(b.namaPertemuan));

    print("Jumlah data: ${_pertemuan.length}");
    setState(() {}); // Trigger widget rebuild setelah data diperbarui
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(
              pageName: "Kelola Pertemuan",
            ),
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
                          Pertemuan(pertemuan: _pertemuan,),
                          // Container(
                          //   height: 600,
                          //   width: double.infinity,
                          //   padding: EdgeInsets.all(appPadding),
                          //   decoration: BoxDecoration(
                          //     color: secondaryColor,
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [PertemuanTable(pertemuan: _pertemuan)],
                          //   ),
                          // ),
                          // PertemuanTable(pertemuan: _pertemuan)
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
