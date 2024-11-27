import 'dart:async';

import 'package:algopintar/screens/detail_materi_screen.dart';
import 'package:algopintar/screens/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MateriScreen extends StatefulWidget {
  final Map<dynamic, dynamic>? materi;
  final Map<dynamic, dynamic>? nextMateri;
  final String username;

  MateriScreen({Key? key, required this.materi, required this.nextMateri, required this.username})
      : super(key: key);

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  int timeLearn = 0;
  late Timer _timer;
  bool _isTimerRunning = true;
  bool _isMateriCompleted = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _checkMateriCompletion();
    if (_isTimerRunning && !_isMateriCompleted) {
      _startTimer();
    }
    final linkYoutube = widget.materi?['linkYoutube'] ?? '';
    final videoId = getYouTubeVideoId(linkYoutube);
    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    } else {
      print("Invalid YouTube link or video ID.");
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _controller?.close();
    super.dispose();
  }

  String? getYouTubeVideoId(String url) {
    final regExp = RegExp(r"(?:v=|\/)([0-9A-Za-z_-]{11})(?:\?|&|$)");
    final match = regExp.firstMatch(url);
    return match != null ? match.group(1) : null;
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
    _isTimerRunning = false;
  }

  Future<void> _checkMateriCompletion() async {
    User? user = _auth.currentUser;
    String? materiId = widget.materi?['idMateri'];
    if (user != null && materiId != null) {
      final subMaterialDoneRef = FirebaseDatabase.instance
          .ref()
          .child('users/${user.uid}/subMaterialDone/$materiId');
      final subMaterialDoneSnapshot = await subMaterialDoneRef.get();
      if (subMaterialDoneSnapshot.exists &&
          subMaterialDoneSnapshot.value == 1) {
        print("Materi sudah selesai");
        setState(() {
          _isMateriCompleted = true;
        });
        _stopTimer();
      }
    }
  }

  // Future<void> _markAsDoneMaterial() async {
  //   User? user = _auth.currentUser;
  //   String? nextMateriId = widget.nextMateri?['idMateri'];
  //   String? materiId = widget.materi?['idMateri'];
  //
  //   if (materiId != null) {
  //     final bobotMateriRef = FirebaseDatabase.instance
  //         .ref()
  //         .child('materialList/$materiId/bobotMateri');
  //     final bobotMateriSnapshot = await bobotMateriRef.get();
  //     print(bobotMateriSnapshot.value.toString());
  //     double bobotMateri = double.parse(bobotMateriSnapshot.value.toString());
  //
  //     final subMaterialDoneRef = FirebaseDatabase.instance
  //         .ref()
  //         .child('users/${user?.uid}/subMaterialDone/$materiId');
  //     await subMaterialDoneRef.set(1);
  //
  //     final progressBelajarRef = FirebaseDatabase.instance
  //         .ref()
  //         .child('users/${user?.uid}/progressBelajar');
  //     final progressBelajarSnapshot = await progressBelajarRef.get();
  //     double progressBelajar =
  //     double.parse(progressBelajarSnapshot.value.toString());
  //     double newProgress = progressBelajar + bobotMateri;
  //     await progressBelajarRef.set(newProgress);
  //   } else {
  //     print('Error: idMateri is null');
  //   }
  //
  //   if (nextMateriId != null) {
  //     final nextMateriRef = FirebaseDatabase.instance
  //         .ref()
  //         .child('users/${user?.uid}/subMaterialDone/$nextMateriId');
  //     await nextMateriRef.set(0);
  //   } else {
  //     print('Error: nextIdMateri is null');
  //   }
  //
  //   final materiIdRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('materialList/$materiId/idPertemuan');
  //   final materiSnapshot = await materiIdRef.get();
  //   final materiData = materiSnapshot.value;
  //   print("materiData $materiData");
  //
  //   final nextMateriIdRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('materialList/$nextMateriId/idPertemuan');
  //   final nextMateriSnapshot = await nextMateriIdRef.get();
  //   final nextMateriData = nextMateriSnapshot.value;
  //
  //   print("nextMateriData $nextMateriData");
  //
  //   final soalPemahamanRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('soalPemahamanList');
  //   final soalPemahamanSnapshot = await soalPemahamanRef.get();
  //   final soalPemahamanData = soalPemahamanSnapshot.value;
  //
  //
  //   // Memanggil QuizScreen untuk mendapatkan hasilnya
  //   int quizResult = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => QuizScreen(
  //         idPertemuan: materiId,
  //         jenisQuiz: 2
  //       ),
  //     ),
  //   );
  //
  //   // Jika hasil quizResult adalah 1, tambahkan poin
  //   if (quizResult == 1) {
  //     final poinRef = FirebaseDatabase.instance.ref().child('users/${user?.uid}/score');
  //     final poinSnapshot = await poinRef.get();
  //     int poin = poinSnapshot.value as int;
  //
  //     if (timeLearn <= 480) {
  //       poin += 3;
  //     } else if (timeLearn > 480 && timeLearn <= 1080) {
  //       poin += 10;
  //     } else {
  //       poin += 1;
  //     }
  //     await poinRef.set(poin);
  //
  //     _dialogBuilder(context, poin - (poinSnapshot.value as int));
  //   } else {
  //     // Jika hasil quizResult bukan 1, poin tidak ditambahkan
  //     print("Quiz tidak berhasil diselesaikan, poin tidak ditambahkan.");
  //     _dialogBuilder(context, 0);
  //   }
  // }

  Future<void> _markAsDoneMaterial() async {
    User? user = _auth.currentUser;
    String? nextMateriId = widget.nextMateri?['idMateri'];
    String? materiId = widget.materi?['idMateri'];

    try {
      if (materiId != null) {
        final bobotMateriRef = FirebaseDatabase.instance
            .ref()
            .child('materialList/$materiId/bobotMateri');
        final bobotMateriSnapshot = await bobotMateriRef.get();

        if (bobotMateriSnapshot.exists) {
          double bobotMateri = double.parse(bobotMateriSnapshot.value.toString());

          final subMaterialDoneRef = FirebaseDatabase.instance
              .ref()
              .child('users/${user?.uid}/subMaterialDone/$materiId');
          await subMaterialDoneRef.set(1);

          final progressBelajarRef = FirebaseDatabase.instance
              .ref()
              .child('users/${user?.uid}/progressBelajar');
          final progressBelajarSnapshot = await progressBelajarRef.get();

          double progressBelajar = progressBelajarSnapshot.exists
              ? double.parse(progressBelajarSnapshot.value.toString())
              : 0.0;

          double newProgress = progressBelajar + bobotMateri;
          await progressBelajarRef.set(newProgress);
        } else {
          print('Error: bobotMateri not found for idMateri $materiId');
        }
      } else {
        print('Error: idMateri is null');
      }

      if (nextMateriId != null) {
        final nextMateriRef = FirebaseDatabase.instance
            .ref()
            .child('users/${user?.uid}/subMaterialDone/$nextMateriId');
        await nextMateriRef.set(0);
      } else {
        print('Error: nextIdMateri is null');
      }

      final soalPemahamanRef = FirebaseDatabase.instance
          .ref()
          .child('soalPemahamanList');
      final soalPemahamanSnapshot = await soalPemahamanRef.get();

      if (soalPemahamanSnapshot.exists) {
        final soalPemahamanData = soalPemahamanSnapshot.value as Map;

        // Cek apakah ada entri dengan idMateri yang cocok
        bool materiExists = soalPemahamanData.values.any((entry) {
          return entry['idMateri'] == materiId;
        });

        if (materiExists) {
          // Memanggil QuizScreen untuk mendapatkan hasilnya
          int quizResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                idPertemuan: materiId,
                jenisQuiz: 2,
              ),
            ),
          );

          // Jika hasil quizResult adalah 1, tambahkan poin
          if (quizResult == 1) {
            final poinRef = FirebaseDatabase.instance
                .ref()
                .child('users/${user?.uid}/score');
            final poinSnapshot = await poinRef.get();
            int poin = poinSnapshot.exists ? poinSnapshot.value as int : 0;

            if (timeLearn <= 480) {
              poin += 3;
            } else if (timeLearn > 480 && timeLearn <= 1080) {
              poin += 10;
            } else {
              poin += 1;
            }
            await poinRef.set(poin);

            print("nama Materi ${widget.materi?['namaMateri']}");
            // Tambahkan data ke historyScoring
            final historyScoringRef = FirebaseDatabase.instance.ref().child('historyScoring').push();
            await historyScoringRef.set({
              'idUser': user?.uid,
              'namaMateri': widget.materi?['namaMateri'] ?? 'Unknown',
              'namaUser': widget.username ?? 'Unknown',
              'skor': (poin - (poinSnapshot.value as int)), // Contoh skor tetap 100, bisa disesuaikan
              'timeLearn': timeLearn,
            });

            _dialogBuilder(context, poin - (poinSnapshot.value as int));
          } else {
            print("Quiz tidak berhasil diselesaikan, poin tidak ditambahkan.");
            // _dialogBuilder(context, 0);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Quiz tidak berhasil diselesaikan, poin tidak ditambahkan.'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ));

            print("nama Materi ${widget.materi?['namaMateri']}");
            // Tambahkan data ke historyScoring
            final historyScoringRef = FirebaseDatabase.instance.ref().child('historyScoring').push();
            await historyScoringRef.set({
              'idUser': user?.uid,
              'namaMateri': widget.materi?['namaMateri'] ?? 'Unknown',
              'namaUser': widget.username ?? 'Unknown',
              'skor': 0, // Contoh skor tetap 100, bisa disesuaikan
              'timeLearn': timeLearn,
            });

            Navigator.of(context).pop();
          }
        } else {
          print("Error: Tidak ada soal yang cocok dengan idMateri $materiId");
          // _dialogBuilder(context, 0);
          Navigator.of(context).pop();
        }
      } else {
        print('Error: soalPemahamanList is empty or does not exist.');
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error during _markAsDoneMaterial execution: $e');
    }
  }

  Future<void> _dialogBuilder(BuildContext context, int poin) {
    IconData iconData = Icons.workspace_premium;
    Color iconColor = Color(0xffE5B80B);
    String title = 'Selamat!';
    String message = 'Terimakasih telah menyelesaikan materi ini. \nPoin yang anda raih sebesar $poin poin';

    if (poin == 10) {
      iconColor = Color(0xffE5B80B);
    } else if (poin == 3) {
      iconColor = Color(0xffC0C0C0);
    } else if (poin == 1) {
      iconColor = Color(0xffCD7F32);
    } else {
      iconData = Icons.error;
      iconColor = Colors.red;
      title = 'Maaf!';
      message = 'Quiz tidak berhasil diselesaikan atau quiz tidak tersedia, tidak ada penambahan poin.';
    }


    // Menggunakan Future.delayed untuk menutup dialog setelah 3 detik
    Future.delayed(Duration(seconds: 3), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Menutup dialog
        Navigator.of(context).pop(); // Menutup MateriScreen
      }
    });


    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              Icon(
                iconData,
                size: 100,
                color: iconColor,
              ),
            ],
          ),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text('Close: ${_countdown.toString()}'),
          //     onPressed: () {
          //       if (Navigator.of(context).canPop()) {
          //         Navigator.of(context).pop();
          //         Navigator.of(context).pop();
          //       }
          //     },
          //   ),
          // ],
        );
      },
    );
  }


  // Future<void> _dialogBuilder(BuildContext context, int poin) {
  //   IconData iconData = Icons.workspace_premium;
  //   Color iconColor = Color(0xffE5B80B);
  //   String title = 'Selamat!';
  //   String message = 'Terimakasih telah menyelesaikan materi ini. \nPoin yang anda raih sebesar $poin poin';
  //
  //   if (poin == 10) {
  //     iconColor = Color(0xffE5B80B);
  //   } else if (poin == 3) {
  //     iconColor = Color(0xffC0C0C0);
  //   } else if (poin == 1) {
  //     iconColor = Color(0xffCD7F32);
  //   }
  //   else {
  //     iconData = Icons.error;
  //     iconColor = Colors.red;
  //     title = 'Maaf!';
  //     message = 'Quiz tidak berhasil diselesaikan atau quiz tidak tersedia, tidak ada penambahan poin.';
  //   }
  //
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               message,
  //               textAlign: TextAlign.center,
  //             ),
  //             Icon(
  //               iconData,
  //               size: 100,
  //               color: iconColor,
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Close'),
  //             onPressed: () {
  //               if(mounted){
  //                 Navigator.of(context).pop();
  //                 Navigator.of(context).pop();
  //               }
  //
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            'Materi: ${timeLearn.toString()} detik',
            style: TextStyle(color: Color(0xff5D60E2), fontWeight: FontWeight.w500),
          ),
          bottom: TabBar(
            labelColor: Color(0xff5D60E2),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xff5D60E2),
            tabs: [
              Tab(text: "Video"),
              Tab(text: "Materi"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: _controller != null
                  ? YoutubePlayer(
                controller: _controller!,
                aspectRatio: 16 / 9,
              )
                  : Text("Tidak ada video yang tersedia, silahkan buka materi!"),
            ),
            widget.materi?['linkPdf'] != null
                ? SfPdfViewer.network(
              widget.materi!['linkPdf'],
              canShowPaginationDialog: true,
            )
                : Center(child: Text("No PDF available")),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: !_isMateriCompleted
              ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5D60E2),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              _stopTimer();
              _markAsDoneMaterial();
            },
            child: const Text("Tandai Selesai"),
          )
              : const SizedBox(),
        ),
      ),
    );
  }
}
