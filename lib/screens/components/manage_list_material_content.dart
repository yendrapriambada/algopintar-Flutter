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
  State<ManageListMaterialContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<ManageListMaterialContent> {
  late DatabaseReference _listMateriRef;
  List<MateriModel> _listMateri = [];

  @override
  void initState() {
    super.initState();
    _listMateriRef = FirebaseDatabase.instance.ref().child('materialList');
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Firebase.initializeApp();
    _listMateriRef.onChildRemoved.listen((event) {
      _listMateri.clear();
      setState(() {}); // Trigger widget rebuild after updating data
    });

    _listMateriRef.orderByChild('idPertemuan').equalTo(widget.idPertemuan).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> listMateriMap = event.snapshot.value as Map<String, dynamic>;
        _updateListMateri(listMateriMap);
      }
    });
  }

  void _updateListMateri(Map<String, dynamic> listMateriMap) {
    _listMateri.clear();
    listMateriMap.forEach((key, value) {
      Map<String, dynamic> listMateriData = value as Map<String, dynamic>;
      MateriModel materi = MateriModel.fromJson(listMateriData, key);
      _listMateri.add(materi);
    });
    _listMateri.sort((a, b) => a.urutanMateri.compareTo(b.urutanMateri));

    setState(() {}); // Trigger widget rebuild after updating data
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
