import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String? idPertemuan;

  QuizScreen({Key? key, required this.idPertemuan}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int jawabanBenar = 0;
  int currentIndex = 0;
  late DatabaseReference _quizList;
  List<Map<dynamic, dynamic>> _quiz = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getQuizList();
  }

  Future<void> _getQuizList() async {
    // for leaderboard
    await Firebase.initializeApp();
    _quizList = FirebaseDatabase.instance.ref().child('soalQuizList');

    _quizList.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> QuizMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        // print(QuizMap);
        _updateQuizList(QuizMap);
      }
    });
  }

  void _updateQuizList(Map<dynamic, dynamic> quizMap) {
    _quiz.clear();
    quizMap.forEach((key, value) {
      if (value['idPertemuan'] == widget.idPertemuan) {
        Map<String, dynamic> quizWithKey =
            Map.from(value); // Create a copy of the material
        quizWithKey['idQuiz'] = key; // Add the key to the material
        _quiz.add(quizWithKey);
      }
    });
    _quiz.sort((a, b) => a['nomorSoal'].compareTo(b['nomorSoal']));
    print("Hasil Akhir: $_quiz");
    setState(() {}); // Trigger widget rebuild after updating data
  }

  Future<void> _dialogBuilder(BuildContext context, int poin) {
    IconData iconData = Icons.workspace_premium;
    Color iconColor = Color(0xffE5B80B);

    if (poin == 100) {
      iconColor = Color(0xffE5B80B);
    } else if (poin == 75) {
      iconColor = Color(0xffC0C0C0);
    } else if (poin == 50) {
      iconColor = Color(0xffCD7F32);
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selamat!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terimakasih telah menyelesaikan quiz ini. \nAnda berhak mendapatkan point sebesar $poin poin',
              ),
              Icon(
                iconData,
                size: 100,
                color: iconColor,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Quiz',
          style:
              TextStyle(color: Color(0xff5D60E2), fontWeight: FontWeight.w500),
        ),
      ),
      body: _quiz.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while waiting for data
          : Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    _quiz[currentIndex]['soal'].toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  // Add your buttons or UI elements here
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5D60E2),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _quiz[currentIndex]['kunciJawaban'] == "A" ? jawabanBenar++ : jawabanBenar;

                          if ((currentIndex + 1) == _quiz.length) {
                            var point = (jawabanBenar / _quiz.length) * 100;
                            _dialogBuilder(context, point.toInt());
                          }
                          else{
                            currentIndex = (currentIndex + 1);
                          }
                        });
                      },
                      child: Text(
                        _quiz[currentIndex]['pilganA'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5D60E2),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _quiz[currentIndex]['kunciJawaban'] == "B" ? jawabanBenar++ : jawabanBenar;

                          if ((currentIndex + 1) == _quiz.length) {
                            var point = (jawabanBenar / _quiz.length) * 100;
                            _dialogBuilder(context, point.toInt());
                          }
                          else{
                            currentIndex = (currentIndex + 1);
                          }
                        });
                      },
                      child: Text(
                        _quiz[currentIndex]['pilganB'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5D60E2),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _quiz[currentIndex]['kunciJawaban'] == "C" ? jawabanBenar++ : jawabanBenar;

                          if ((currentIndex + 1) == _quiz.length) {
                            var point = (jawabanBenar / _quiz.length) * 100;
                            _dialogBuilder(context, point.toInt());
                          }
                          else{
                            currentIndex = (currentIndex + 1);
                          }
                        });
                      },
                      child: Text(
                        _quiz[currentIndex]['pilganC'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5D60E2),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _quiz[currentIndex]['kunciJawaban'] == "D" ? jawabanBenar++ : jawabanBenar;

                          if ((currentIndex + 1) == _quiz.length) {
                            var point = (jawabanBenar / _quiz.length) * 100;
                            _dialogBuilder(context, point.toInt());
                          }
                          else{
                            currentIndex = (currentIndex + 1);
                          }
                        });
                      },
                      child: Text(
                        _quiz[currentIndex]['pilganD'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
