import 'package:flutter/services.dart';
import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/components/pertemuan_table.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

import 'list_materi_table.dart';

class ListMateri extends StatefulWidget {
  final List<MateriModel> listMateri;
  final String idPertemuan;

  const ListMateri(
      {Key? key, required this.listMateri, required this.idPertemuan})
      : super(key: key);

  @override
  State<ListMateri> createState() => _ListMateriState();
}

class _ListMateriState extends State<ListMateri> {
  late DatabaseReference _listMateriRef;
  final TextEditingController _urutanMateriController = TextEditingController();
  final TextEditingController _namaMateriController = TextEditingController();
  final TextEditingController _linkPDFController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urutanMateriController.dispose();
    _namaMateriController.dispose();
    _linkPDFController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Data Materi",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: textColor,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _showSimpleModalDialog(context);
                },
                child: Text(
                  "Tambah Materi",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 18,
                  ),
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // <-- Radius
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListMateriTable(listMateri: widget.listMateri, idPertemuan: widget.idPertemuan),
          )
        ],
      ),
    );
  }

  _showSimpleModalDialog(context) {
    _urutanMateriController.clear();
    _namaMateriController.clear();
    _linkPDFController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
                constraints: BoxConstraints(
                    minHeight: 300,
                    maxHeight: 600,
                    minWidth: 300,
                    maxWidth: 500),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Tambah Materi${100 / (widget.listMateri.length + 1)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _urutanMateriController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Urutan Materi (angka)",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter a value';
                                else
                                  return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _namaMateriController,
                              decoration: InputDecoration(
                                labelText: "Nama Materi",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter a value';
                                else
                                  return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _linkPDFController,
                              decoration: InputDecoration(
                                labelText: "Link PDF Materi (cdn url)",
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 4,
                              minLines: 3,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter a value';
                                else
                                  return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                                  ),
                                ),
                                child: Text('Batal',
                                    style: TextStyle(color: primaryColor)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _addMateriCheck();
                                    }
                                  },
                                  child: const Text(
                                    'Tambah Materi',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5D60E2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8), // <-- Radius
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                )),
          );
        });
  }

  void _addMateriCheck() async {
    String urutan = _urutanMateriController.text;
    String name = _namaMateriController.text;
    String linkPdf = _linkPDFController.text;
    double bobotMateri = 100 / (widget.listMateri.length + 1);
    print("bobotMateri ${bobotMateri}");

    _listMateriRef = FirebaseDatabase.instance.ref().child('materialList');

    if (widget.listMateri.isEmpty) {
      print("Belum ada data materi");
      _saveMateri(urutan, name, linkPdf, bobotMateri);
    } else {
      if (widget.listMateri.any((element) => element.urutanMateri == urutan)) {
        // print(snapshot.value);
        print("Urutan Materi Ke-${urutan} sudah ada");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Urutan Materi Ke-${urutan} sudah ada'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
        Navigator.pop(context);
      } else {
        print('No data available.');
        _saveMateri(urutan, name, linkPdf, bobotMateri);
      }
    }
  }

  void _saveMateri(String urutan, String name, String linkPdf, double bobotMateri) async {
    _listMateriRef.push().set({
      'urutanMateri': urutan,
      'namaMateri': name,
      'linkPdf': linkPdf,
      'idPertemuan': widget.idPertemuan,
      'bobotMateri': bobotMateri,
    }).then((_) {
      // Data saved successfully!
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Materi berhasil ditambah!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
      _updateBobotMateriBulk(bobotMateri);
      Navigator.pop(context);
    }).catchError((error) {
      // The write failed...
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Materi gagal ditambah!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }

  void _updateBobotMateriBulk(double bobotMateri) async {
    // Ambil referensi ke daftar materi pada Firebase
    DatabaseReference materiRef = FirebaseDatabase.instance
        .ref()
        .child('materialList');

    // Ambil snapshot materi berdasarkan idPertemuan
    DataSnapshot snapshot = await materiRef
        .orderByChild('idPertemuan')
        .equalTo(widget.idPertemuan)
        .get();

    // Iterasi semua materi pada pertemuan tertentu
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    print("data yaaaaaaaaaaa: ${data}");
    data.forEach((key, value) {
      // Update bobotMateri untuk materi saat ini
      materiRef.child(key).update({
        'bobotMateri': bobotMateri,
      });
    });
  }

}
