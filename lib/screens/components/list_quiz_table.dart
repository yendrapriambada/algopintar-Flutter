import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../constants/constants.dart';
import '../../models/mata_pelajaran_model.dart';

class ListQuizTable extends StatefulWidget {
  final List<Quizmodel> listQuiz;

  const ListQuizTable({Key? key, required this.listQuiz}) : super(key: key);

  @override
  _ListQuizTableState createState() => _ListQuizTableState();
}

class _ListQuizTableState extends State<ListQuizTable> {
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        height: (60 * (widget.listQuiz.length + 1)) + 40,
        child: DataTable2(
          columnSpacing: 12,
          dataRowHeight: 100,
          headingRowHeight: 40,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(label: Text("No.", style: TextStyle(fontWeight: FontWeight.bold)), fixedWidth: 50),
            DataColumn2(label: Text('Soal', style: TextStyle(fontWeight: FontWeight.bold)), size: ColumnSize.L,),
            DataColumn2(label: Text('Pilgan A', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn2(label: Text('Pilgan B', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn2(label: Text('Pilgan C', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn2(label: Text('Pilgan D', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn2(label: Text('Kunci Jawaban', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn2(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List<DataRow>.generate(
            widget.listQuiz.length,
            (index) {
              final quiz = widget.listQuiz[index];
              return DataRow(
                cells: [
                  DataCell(Text(quiz.nomorSoal)),
                  DataCell(Text(quiz.soal)),
                  DataCell(Text(quiz.pilganA)),
                  DataCell(Text(quiz.pilganB)),
                  DataCell(Text(quiz.pilganC)),
                  DataCell(Text(quiz.pilganD)),
                  DataCell(Text(quiz.kunciJawaban)),
                  DataCell(
                    Wrap(
                      spacing: 8, // Jarak horizontal antar elemen
                      runSpacing: 4, // Jarak vertikal antar elemen
                      alignment: WrapAlignment.center, // Posisi elemen di tengah
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Icon(Icons.edit, size: 16),
                          onPressed: () {
                            _showSimpleModalDialog(
                              context,
                              quiz.id,
                              quiz.nomorSoal,
                              quiz.soal,
                              quiz.pilganA,
                              quiz.pilganB,
                              quiz.pilganC,
                              quiz.pilganD,
                              quiz.kunciJawaban,
                            );
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Icon(Icons.delete, size: 16),
                          onPressed: () {
                            _showDeleteConfirmationDialog(quiz.id);
                          },
                        ),
                      ],
                    ),
                  ),

                  // DataCell(Column(
                  //   children: [
                  //     SizedBox(
                  //       height: 8,
                  //     ),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.orange,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(6), // <-- Radius
                  //         ),
                  //       ),
                  //       child: Icon(
                  //         Icons.edit,
                  //         size: 16,
                  //       ),
                  //       onPressed: () {
                  //         _showSimpleModalDialog(
                  //             context,
                  //             quiz.id,
                  //             quiz.nomorSoal,
                  //             quiz.soal,
                  //             quiz.pilganA,
                  //             quiz.pilganB,
                  //             quiz.pilganC,
                  //             quiz.pilganD,
                  //             quiz.kunciJawaban);
                  //       },
                  //     ),
                  //     SizedBox(
                  //       height: 8,
                  //     ),
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.red,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(6), // <-- Radius
                  //         ),
                  //       ),
                  //       child: Icon(
                  //         Icons.delete,
                  //         size: 16,
                  //       ),
                  //       onPressed: () {
                  //         _showDeleteConfirmationDialog(quiz.id);
                  //       },
                  //     ),
                  //   ],
                  // )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _showSimpleModalDialog(context, String quizId, String nomorSoal, String soal,
      String pilganA, String pilganB, String pilganC, String pilganD, String kunciJawaban) {
    _nomorSoalController.text = nomorSoal;
    _soalController.text = soal;
    _pilganAController.text = pilganA;
    _pilganBController.text = pilganB;
    _pilganCController.text = pilganC;
    _pilganDController.text = pilganD;
    _kunciJawabanController.text = kunciJawaban;

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
                              "Edit Soal Quiz",
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
                                      _editSoal(quizId);
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

  void _editSoal(String quizId) {
    DatabaseReference pertemuanRef =
        FirebaseDatabase.instance.ref().child('soalQuizList').child(quizId);

    Map<String, dynamic> updatedData = {
      "nomorSoal": _nomorSoalController.text,
      "soal": _soalController.text,
      "pilganA": _pilganAController.text,
      "pilganB": _pilganBController.text,
      "pilganC": _pilganCController.text,
      "pilganD": _pilganDController.text,
      "kunciJawaban": _kunciJawabanController.text,
    };

    pertemuanRef.update(updatedData).then((_) {
      print("Data Soal updated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Soal berhasil diupdate!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
      Navigator.pop(context);
    }).catchError((onError) {
      print("Failed to update Soal: $onError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Soal gagal diupdate: $onError'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }

  void _showDeleteConfirmationDialog(String quizId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi hapus data'),
          content: Text('Apakah kamu yakin ingin menghapus data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteSoal(quizId); // Call the function to delete
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteSoal(String quizId) async {
    _listQuizRef =
        FirebaseDatabase.instance.ref().child('soalQuizList').child(quizId);

    _listQuizRef.remove().then((_) {
      print("Soal Quiz deleted successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Soal berhasil dihapus!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    }).catchError((onError) {
      print("Failed to delete Soal: $onError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Soal gagal dihapus: $onError'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }
}
