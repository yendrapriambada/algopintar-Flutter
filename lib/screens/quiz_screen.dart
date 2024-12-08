import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String? idPertemuan;
  final int jenisQuiz;
  final String username;
  // final String? idMateri;

  QuizScreen({Key? key, required this.idPertemuan, required this.jenisQuiz, required this.username}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int jawabanBenar = 0;
  int currentIndex = 0;
  late DatabaseReference _quizList;
  late DatabaseReference _soalPemahaman;
  List<Map<dynamic, dynamic>> _quiz = [];
  List<Map<dynamic, dynamic>> _soalPemahamanSiswa = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? namaPertemuan; // Untuk menyimpan nama pertemuan
  late Timer _timer;
  int timeLearn = 0; // Untuk menyimpan durasi quiz

  @override
  void initState() {
    super.initState();
    _getQuizList();
    _getNamaPertemuan(); // Memanggil namaPertemuan berdasarkan id
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        timeLearn++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  // Fungsi untuk mengambil namaPertemuan berdasarkan idPertemuan
  Future<void> _getNamaPertemuan() async {
    final pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan');
    final snapshot = await pertemuanRef.child(widget.idPertemuan!).get();
    if (snapshot.exists) {
      setState(() {
        namaPertemuan = snapshot.child('namaPertemuan').value.toString();
      });
    }
  }

  Future<void> _getQuizList() async {
    if (widget.jenisQuiz == 1) {
      await Firebase.initializeApp();
      _quizList = FirebaseDatabase.instance.ref().child('soalQuizList');
    } else {
      await Firebase.initializeApp();
      _quizList = FirebaseDatabase.instance.ref().child('soalPemahamanList');
    }


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
    if (widget.jenisQuiz == 1) {
      quizMap.forEach((key, value) {
        if (value['idPertemuan'] == widget.idPertemuan) {
          Map<String, dynamic> quizWithKey =
              Map.from(value); // Create a copy of the material
          quizWithKey['idQuiz'] = key; // Add the key to the material
          _quiz.add(quizWithKey);
        }
      });
    } else {
      quizMap.forEach((key, value) {
        if (value['idMateri'] == widget.idPertemuan) {
          Map<String, dynamic> quizWithKey =
              Map.from(value); // Create a copy of the material
          quizWithKey['idQuiz'] = key; // Add the key to the material
          _quiz.add(quizWithKey);
        }
      });
    }

    _quiz.sort((a, b) => a['nomorSoal'].compareTo(b['nomorSoal']));
    print("Hasil Akhir: $_quiz");
    setState(() {}); // Trigger widget rebuild after updating data
  }

  Future<void> _dialogBuilder(BuildContext context, int poin) async {
    User? user = _auth.currentUser;
    IconData iconData = Icons.workspace_premium;
    Color iconColor = Color(0xffE5B80B);

    // Tentukan warna berdasarkan poin
    if (poin == 100) {
      iconColor = Color(0xffE5B80B);
    } else if (poin == 75) {
      iconColor = Color(0xffC0C0C0);
    } else if (poin == 50) {
      iconColor = Color(0xffCD7F32);
    }

    _stopTimer();

    if (widget.jenisQuiz == 1) {
      // Tambahkan poin ke database
      final poinRef = FirebaseDatabase.instance.ref().child('users/${user?.uid}/score');
      final poinSnapshot = await poinRef.get();
      int currentPoin = (poinSnapshot.value ?? 0) as int;

      // Tambahkan poin baru
      await poinRef.set(currentPoin + poin);

      // Tambahkan data ke historyScoring
      final historyScoringRef = FirebaseDatabase.instance.ref().child('historyScoring').push();
      await historyScoringRef.set({
        'idUser': user?.uid,
        'namaMateri': 'Quiz - Pertemuan ${namaPertemuan} ',
        'namaUser': widget.username,
        'skor': poin, // Contoh skor tetap 100, bisa disesuaikan
        'timeLearn': timeLearn,
      });

      // Tampilkan dialog
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selamat!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terimakasih telah menyelesaikan quiz ini.\n'
                      'Anda berhak mendapatkan poin sebesar $poin.',
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
    } else if (widget.jenisQuiz == 2) {
      // Navigasi berdasarkan nilai poin
      if (poin == 100) {
        Navigator.of(context).pop(1); // Return 1 jika poin 100
        // Navigator.of(context).pop(1); // Return 1 jika poin 100
      } else {
        Navigator.of(context).pop(0); // Return 0 jika poin tidak 100
        // Navigator.of(context).pop(0); // Return 0 jika poin tidak 100
      }
    }
  }



  // Future<void> _getSoalPemahaman() async {
  //   // for leaderboard
  //   await Firebase.initializeApp();
  //   _soalPemahaman= FirebaseDatabase.instance.ref().child('soalPemahaman');
  //
  //   _soalPemahaman.onValue.listen((event) {
  //     if (event.snapshot.value != null) {
  //       Map<dynamic, dynamic> soalPemahamanMap =
  //       event.snapshot.value as Map<dynamic, dynamic>;
  //       // print(QuizMap);
  //       _updateSoalPemahaman(soalPemahamanMap);
  //     }
  //   });
  // }
  //
  // void _updateSoalPemahaman(Map<dynamic, dynamic> soalPemahamanMap) {
  //   _soalPemahamanSiswa.clear();
  //   soalPemahamanMap.forEach((key, value) {
  //     if (value['idMateri'] == widget.idMateri) {
  //       Map<String, dynamic> soalPemahamanWithKey =
  //       Map.from(value); // Create a copy of the material
  //       soalPemahamanWithKey['idSoalPemahaman'] = key; // Add the key to the material
  //       _soalPemahamanSiswa.add(soalPemahamanWithKey);
  //     }
  //   });
  //   _soalPemahamanSiswa.sort((a, b) => a['nomorSoal'].compareTo(b['nomorSoal']));
  //   print("Hasil Akhir: $_soalPemahamanSiswa");
  //   setState(() {}); // Trigger widget rebuild after updating data
  // }


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
        title: widget.jenisQuiz == 1 ? Text(
          'Quiz',
          style:
              TextStyle(color: Color(0xff5D60E2), fontWeight: FontWeight.w500),
        ): Text(
          'Soal Pemahaman',
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
