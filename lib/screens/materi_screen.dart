import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/mata_pelajaran_model.dart';

class MateriScreen extends StatelessWidget {
  final Map<dynamic, dynamic>? materi;

  const MateriScreen({Key? key, required this.materi}) : super(key: key);

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
        title: const Text(
          'Materi',
          style:
              TextStyle(color: Color(0xff5D60E2), fontWeight: FontWeight.w500),
        ),
      ),
      body: SfPdfViewer.network(materi?['linkPdf']),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {},
              ),
              Text(materi?['namaMateri']),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
