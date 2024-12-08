import 'package:flutter/services.dart';
import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'list_quiz_table.dart';

class ListQuiz extends StatefulWidget {
  final List<Quizmodel> listQuiz;
  final String idPertemuan;

  const ListQuiz(
      {Key? key, required this.listQuiz, required this.idPertemuan})
      : super(key: key);

  @override
  State<ListQuiz> createState() => _ListQuizState();
}

class _ListQuizState extends State<ListQuiz> {
  late DatabaseReference _listQuizRef;
  final TextEditingController _nomorSoalController = TextEditingController();
  final TextEditingController _soalController = TextEditingController();
  final TextEditingController _pilganAController = TextEditingController();
  final TextEditingController _pilganBController = TextEditingController();
  final TextEditingController _pilganCController = TextEditingController();
  final TextEditingController _pilganDController = TextEditingController();
  final TextEditingController _kunciJawabanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomorSoalController.dispose();
    _soalController.dispose();
    _pilganAController.dispose();
    _pilganBController.dispose();
    _pilganCController.dispose();
    _pilganDController.dispose();
    _kunciJawabanController.dispose();
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
                "Data Soal Quiz tiap Pertemuan",
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
                  "Tambah Soal",
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
            child: ListQuizTable(listQuiz: widget.listQuiz),
          )
        ],
      ),
    );
  }

  _showSimpleModalDialog(context) {
    _nomorSoalController.clear();
    _soalController.clear();
    _pilganAController.clear();
    _pilganBController.clear();
    _pilganCController.clear();
    _pilganDController.clear();
    _kunciJawabanController.clear();

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
                              "Tambah Soal",
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
                              controller: _nomorSoalController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Nomor Soal (angka)",
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
                              controller: _soalController,
                              decoration: InputDecoration(
                                labelText: "Soal",
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
                              controller: _pilganAController,
                              decoration: InputDecoration(
                                labelText: "Deskripsi Pilgan A",
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
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _pilganBController,
                              decoration: InputDecoration(
                                labelText: "Deskripsi Pilgan B",
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
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _pilganCController,
                              decoration: InputDecoration(
                                labelText: "Deskripsi Pilgan C",
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
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _pilganDController,
                              decoration: InputDecoration(
                                labelText: "Deskripsi Pilgan D",
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
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _kunciJawabanController,
                              decoration: InputDecoration(
                                labelText: "Kunci Jawaban",
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
                                      _addsoalCheck();
                                    }
                                  },
                                  child: const Text(
                                    'Simpan',
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

  void _addsoalCheck() async {
    String nomorSoal = _nomorSoalController.text;
    String soal = _soalController.text;
    String pilganA = _pilganAController.text;
    String pilganB = _pilganBController.text;
    String pilganC = _pilganCController.text;
    String pilganD = _pilganDController.text;
    String kunciJawaban = _kunciJawabanController.text;

    _listQuizRef = FirebaseDatabase.instance.ref().child('soalQuizList');

    if (widget.listQuiz.isEmpty) {
      print("Belum ada data quiz");
      _saveQuiz(nomorSoal, soal, pilganA, pilganB, pilganC, pilganD, kunciJawaban);
    } else {
      if (widget.listQuiz.any((element) => element.nomorSoal == nomorSoal)) {
        // print(snapshot.value);
        print("Nomor Soal Ke-${nomorSoal} sudah ada");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nomor Soal Ke-${nomorSoal} sudah ada'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
        Navigator.pop(context);
      } else {
        print('No data available.');
        _saveQuiz(nomorSoal, soal, pilganA, pilganB, pilganC, pilganD, kunciJawaban);
      }
    }
  }

  void _saveQuiz(String nomorSoal, String soal, String pilganA, String pilganB, String pilganC, String pilganD, String kunciJawaban) async {
    _listQuizRef.push().set({
      'nomorSoal': nomorSoal,
      'soal': soal,
      'pilganA': pilganA,
      'pilganB': pilganB,
      'pilganC': pilganC,
      'pilganD': pilganD,
      'kunciJawaban': kunciJawaban,
      'idPertemuan': widget.idPertemuan,
    }).then((_) {
      // Data saved successfully!
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Soal Quiz berhasil ditambah!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
      Navigator.pop(context);
    }).catchError((error) {
      // The write failed...
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Soal Quiz gagal ditambah!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }
}
