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
import 'list_quiz.dart';


class ManageListQuizContent extends StatefulWidget {
  final String idPertemuan;
  const ManageListQuizContent({Key? key, required this.idPertemuan}) : super(key: key);

  @override
  State<ManageListQuizContent> createState() => _ManageListQuizContentState();
}

class _ManageListQuizContentState extends State<ManageListQuizContent> {
  late DatabaseReference _listQuizRef;
  List<Quizmodel> _listQuiz = [];

  @override
  void initState() {
    super.initState();
    _listQuizRef = FirebaseDatabase.instance.ref().child('soalQuizList');
    _initializeDatabase();
  }
  Future<void> _initializeDatabase() async {
    // Inisialisasi Firebase
    await Firebase.initializeApp();

    // Listener untuk data yang dihapus
    _listQuizRef.onChildRemoved.listen((event) {
      _listQuiz.clear();
      setState(() {}); // Trigger widget rebuild setelah data dihapus
    });

    // Listener untuk data sesuai dengan idPertemuan
    _listQuizRef
        .orderByChild('idPertemuan')
        .equalTo(widget.idPertemuan)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        print("Debugging Data: ${event.snapshot.value.runtimeType}");
        // Validasi tipe data sebelum di-cast
        if (event.snapshot.value is Map<Object?, Object?>) {
          // Konversi tipe data ke Map<String, dynamic>
          Map<String, dynamic> listQuizMap = (event.snapshot.value as Map)
              .map((key, value) => MapEntry(key.toString(), value));

          _updateListQuiz(listQuizMap);
        } else {
          print("Tipe data tidak sesuai: ${event.snapshot.value.runtimeType}");
        }
      } else {
        print("Tidak ada data");
      }
    });
  }

  void _updateListQuiz(Map<String, dynamic> listQuizMap) {
    _listQuiz.clear();

    // Iterasi data untuk memproses setiap item
    listQuizMap.forEach((key, value) {
      if (value is Map) {
        // Validasi tipe data sebelum parsing
        Map<String, dynamic> listQuizData =
        value.map((k, v) => MapEntry(k.toString(), v));
        try {
          Quizmodel quiz = Quizmodel.fromJson(listQuizData, key);
          _listQuiz.add(quiz);
        } catch (e) {
          print("Error parsing data untuk key $key: $e");
        }
      } else {
        print("Data dengan key $key tidak valid: ${value.runtimeType}");
      }
    });

    // Sorting daftar quiz berdasarkan nomorSoal
    _listQuiz.sort((a, b) => a.nomorSoal.compareTo(b.nomorSoal));

    print("Jumlah data quiz: ${_listQuiz.length}");
    setState(() {}); // Trigger widget rebuild setelah data diperbarui
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(pageName: "Kelola Soal Quiz",),
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
                          ListQuiz(listQuiz: _listQuiz, idPertemuan: widget.idPertemuan,),
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
                            child: DashBoardScreen(contentType: ContentType.Quiz,)
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
