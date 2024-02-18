import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/mata_pelajaran_model.dart';

class MateriScreen extends StatelessWidget {
  final Map<dynamic, dynamic>? materi;
  final Map<dynamic, dynamic>? nextMateri;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MateriScreen({Key? key, required this.materi, required this.nextMateri}) : super(key: key);

  Future<void> _markAsDoneMaterial() async {
    User? user = _auth.currentUser;
    String? nextMateriId = nextMateri?['idMateri'];
    String? materiId = materi?['idMateri'];

    if (materiId != null) {
      // Mendapatkan bobot materi dari Firebase
      final bobotMateriRef = FirebaseDatabase.instance.ref().child('materialList/$materiId/bobotMateri');
      final bobotMateriSnapshot = await bobotMateriRef.get();
      print(bobotMateriSnapshot.value.toString());
      double bobotMateri = double.parse(bobotMateriSnapshot.value.toString());

      // Menyimpan status materi yang sudah selesai
      final subMaterialDoneRef = FirebaseDatabase.instance.ref().child('users/${user?.uid}/subMaterialDone/$materiId');
      await subMaterialDoneRef.set(1);

      // Menambahkan bobot materi ke progress belajar
      final progressBelajarRef = FirebaseDatabase.instance.ref().child('users/${user?.uid}/progressBelajar');
      final progressBelajarSnapshot = await progressBelajarRef.get();
      double progressBelajar = double.parse(progressBelajarSnapshot.value.toString());
      double newProgress = progressBelajar + bobotMateri;
      await progressBelajarRef.set(newProgress);
    } else {
      print('Error: idMateri is null');
    }

    if (nextMateriId != null) {
      // Mengupdate status materi selanjutnya
      final nextMateriRef = FirebaseDatabase.instance.ref().child('users/${user?.uid}/subMaterialDone/$nextMateriId');
      await nextMateriRef.set(0);
    } else {
      print('Error: nextIdMateri is null');
    }
  }



  @override
  Widget build(BuildContext context) {
    print(materi);
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
        title: const Text(
          'Materi',
          style:
              TextStyle(color: Color(0xff5D60E2), fontWeight: FontWeight.w500),
        ),
      ),
      body: SfPdfViewer.network(materi?['linkPdf']),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xff5D60E2),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            _markAsDoneMaterial();
            Navigator.pop(context);
          },
          child: const Text('Selesai', style: TextStyle( color: Colors.white),)
        ),
      ),


      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 5.0,
      //   clipBehavior: Clip.antiAlias,
      //   child: SizedBox(
      //     height: kBottomNavigationBarHeight,
      //     child: Row(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         IconButton(
      //           icon: const Icon(Icons.arrow_left),
      //           onPressed: () {},
      //         ),
      //         Text(materi?['namaMateri']),
      //         IconButton(
      //           icon: const Icon(Icons.arrow_right),
      //           onPressed: () {
      //             // Navigator.push(
      //             //   context,
      //             //   MaterialPageRoute(
      //             //     builder: (context) => MateriScreen(
      //             //       materi: materi,
      //             //     ),
      //             //   ),
      //             // );
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
