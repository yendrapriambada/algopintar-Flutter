import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MateriScreen extends StatefulWidget {
  final Map<dynamic, dynamic>? materi;
  final Map<dynamic, dynamic>? nextMateri;

  MateriScreen({Key? key, required this.materi, required this.nextMateri})
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

  @override
  void initState() {
    super.initState();
    _loadTimeLearn();
    _checkMateriCompletion();
    if (_isTimerRunning && !_isMateriCompleted) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _saveTimeLearn();
    super.dispose();
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

  Future<void> _loadTimeLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timeLearn = prefs.getInt('timeLearn') ?? 0;
    });
  }

  Future<void> _saveTimeLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeLearn', timeLearn);
  }

  Future<void> _resetTimeLearn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timeLearn = 0;
    });
    await prefs.remove('timeLearn');
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
        _stopTimer(); // Hentikan timer saat materi selesai
      }
    }
  }

  Future<void> _markAsDoneMaterial() async {
    User? user = _auth.currentUser;
    String? nextMateriId = widget.nextMateri?['idMateri'];
    String? materiId = widget.materi?['idMateri'];

    if (materiId != null) {
      // Mendapatkan bobot materi dari Firebase
      final bobotMateriRef = FirebaseDatabase.instance
          .ref()
          .child('materialList/$materiId/bobotMateri');
      final bobotMateriSnapshot = await bobotMateriRef.get();
      print(bobotMateriSnapshot.value.toString());
      double bobotMateri = double.parse(bobotMateriSnapshot.value.toString());

      // Menyimpan status materi yang sudah selesai
      final subMaterialDoneRef = FirebaseDatabase.instance
          .ref()
          .child('users/${user?.uid}/subMaterialDone/$materiId');
      await subMaterialDoneRef.set(1);

      // Menambahkan bobot materi ke progress belajar
      final progressBelajarRef = FirebaseDatabase.instance
          .ref()
          .child('users/${user?.uid}/progressBelajar');
      final progressBelajarSnapshot = await progressBelajarRef.get();
      double progressBelajar =
          double.parse(progressBelajarSnapshot.value.toString());
      double newProgress = progressBelajar + bobotMateri;
      await progressBelajarRef.set(newProgress);
    } else {
      print('Error: idMateri is null');
    }

    if (nextMateriId != null) {
      // Mengupdate status materi selanjutnya
      final nextMateriRef = FirebaseDatabase.instance
          .ref()
          .child('users/${user?.uid}/subMaterialDone/$nextMateriId');
      await nextMateriRef.set(0);
    } else {
      print('Error: nextIdMateri is null');
    }

    // cek jika nextMateriId.idPertemuan != materiId.idPertemuan, maka kalkulasi poinya
    final materiIdRef = FirebaseDatabase.instance
        .ref()
        .child('materialList/$materiId/idPertemuan');
    final materiSnapshot = await materiIdRef.get();
    final materiData = materiSnapshot.value;
    print("materiData ${materiData}");

    final nextMateriIdRef = FirebaseDatabase.instance
        .ref()
        .child('materialList/$nextMateriId/idPertemuan');
    final nextMateriSnapshot = await nextMateriIdRef.get();
    final nextMateriData = nextMateriSnapshot.value;

    print("nextMateriData ${nextMateriData}");

    if (materiData != nextMateriData) {
      final poinRef =
          FirebaseDatabase.instance.ref().child('users/${user?.uid}/score');
      final poinSnapshot = await poinRef.get();
      int poin = poinSnapshot.value as int;
      // if (timeLearn < 900) {
      //   // < 15 menit
      //   poin += 50;
      // } else if (timeLearn >= 900 && timeLearn <= 3600) {
      //   // 15 menit - 1 jam
      //   poin += 100;
      // } else if (timeLearn > 3600) {
      //   // > 1 jam
      //   poin += 75;
      // }

      if (timeLearn < 5) {
        // < 15 menit
        poin += 50;
      } else if (timeLearn >= 5 && timeLearn <= 10) {
        // 15 menit - 1 jam
        poin += 100;
      } else if (timeLearn > 10) {
        // > 1 jam
        poin += 75;
      }
      await poinRef.set(poin);
      _resetTimeLearn();
      _dialogBuilder(context, poin - (poinSnapshot.value as int));
    }
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
                'Terimakasih telah menyelesaikan materi ini. \nAnda berhak mendapatkan point sebesar $poin poin',
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
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    print(widget.materi);
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
          'Materi: ${timeLearn.toString()} detik',
          style:
              TextStyle(color: Color(0xff5D60E2), fontWeight: FontWeight.w500),
        ),
      ),
      body: SfPdfViewer.network(widget.materi?['linkPdf']),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: !_isMateriCompleted
            ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5D60E2),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              _stopTimer(); // Hentikan timer saat tombol Selesai ditekan
              _markAsDoneMaterial();
              Navigator.pop(context);
            },
            child: const Text(
              'Selesai',
              style: TextStyle(color: Colors.white),
            )): SizedBox(),
      ),
    );
  }
}
