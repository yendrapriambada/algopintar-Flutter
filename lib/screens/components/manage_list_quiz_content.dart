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
    await Firebase.initializeApp();
    _listQuizRef.onChildRemoved.listen((event) {
      _listQuiz.clear();
      setState(() {}); // Trigger widget rebuild after updating data
    });

    _listQuizRef.orderByChild('idPertemuan').equalTo(widget.idPertemuan).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> listQuizMap = event.snapshot.value as Map<String, dynamic>;
        _updateListQuiz(listQuizMap);
      }
    });
  }

  void _updateListQuiz(Map<String, dynamic> listQuizMap) {
    _listQuiz.clear();
    listQuizMap.forEach((key, value) {
      Map<String, dynamic> listQuizData = value as Map<String, dynamic>;
      Quizmodel quiz = Quizmodel.fromJson(listQuizData, key);
      _listQuiz.add(quiz);
    });
    _listQuiz.sort((a, b) => a.nomorSoal.compareTo(b.nomorSoal));

    setState(() {}); // Trigger widget rebuild after updating data
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
