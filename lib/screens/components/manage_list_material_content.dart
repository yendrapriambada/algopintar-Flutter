import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/screens/components/custom_appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../../controllers/controller.dart';
import '../../models/mata_pelajaran_model.dart';
import '../dash_board_screen.dart';
import 'list_materi.dart';


class ManageListMaterialContent extends StatefulWidget {
  final String idPertemuan;
  const ManageListMaterialContent({Key? key, required this.idPertemuan}) : super(key: key);

  @override
  State<ManageListMaterialContent> createState() => _ManageListMaterialContentState();
}

class _ManageListMaterialContentState extends State<ManageListMaterialContent> {
  late DatabaseReference _listMateriRef;
  List<MateriModel> _listMateri = [];

  @override
  void initState() {
    super.initState();
    _listMateriRef = FirebaseDatabase.instance.ref().child('materialList');
    _initializeDatabase();
  }
  Future<void> _initializeDatabase() async {
    // Inisialisasi Firebase
    await Firebase.initializeApp();

    // Listener untuk data yang dihapus
    _listMateriRef.onChildRemoved.listen((event) {
      _listMateri.clear();
      setState(() {}); // Trigger widget rebuild setelah data diubah
    });

    // Listener untuk data yang sesuai dengan idPertemuan
    _listMateriRef
        .orderByChild('idPertemuan')
        .equalTo(widget.idPertemuan)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        print("Data ada: ${event.snapshot.value.runtimeType}");
        // Validasi tipe data sebelum di-cast
        if (event.snapshot.value is Map<Object?, Object?>) {
          // Konversi tipe data ke Map<String, dynamic>
          Map<String, dynamic> listMateriMap = (event.snapshot.value as Map)
              .map((key, value) => MapEntry(key.toString(), value));

          _updateListMateri(listMateriMap);
        } else {
          print("Tipe data tidak sesuai: ${event.snapshot.value.runtimeType}");
        }
      } else {
        print("Tidak ada data");
      }
    });
  }

  void _updateListMateri(Map<String, dynamic> listMateriMap) {
    _listMateri.clear();

    // Iterasi data untuk memproses setiap item
    listMateriMap.forEach((key, value) {
      if (value is Map) {
        // Validasi tipe data sebelum parsing
        Map<String, dynamic> listMateriData =
        value.map((k, v) => MapEntry(k.toString(), v));
        try {
          MateriModel materi = MateriModel.fromJson(listMateriData, key);
          _listMateri.add(materi);
        } catch (e) {
          print("Error parsing data untuk key $key: $e");
        }
      } else {
        print("Data dengan key $key tidak valid: ${value.runtimeType}");
      }
    });

    // Sorting daftar materi
    _listMateri.sort((a, b) => a.urutanMateri.compareTo(b.urutanMateri));

    print("Jumlah data materi: ${_listMateri.length}");
    setState(() {}); // Trigger widget rebuild setelah data diperbarui
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(pageName: "Kelola List Materi",),
            const BackButton(),
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
                          ListMateri(listMateri: _listMateri, idPertemuan: widget.idPertemuan,),
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

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        MultiProvider(
                            providers: [
                              ChangeNotifierProvider(create: (context) => Controller(),)
                            ],
                            child: DashBoardScreen(contentType: ContentType.Material,)
                        ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              icon: Icon(Icons.arrow_back),  //icon data for elevated button
              label: Text("Kembali",), //label text
            ),
          ],
        ),
      ),
    );
  }
}
