import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../controllers/controller.dart';
import '../../models/mata_pelajaran_model.dart';
import '../dash_board_screen.dart';

class QuizPertemuanTable extends StatefulWidget {
  final List<PertemuanModel> pertemuan;

  const QuizPertemuanTable({Key? key, required this.pertemuan}) : super(key: key);

  @override
  _QuizPertemuanTableState createState() => _QuizPertemuanTableState();
}

class _QuizPertemuanTableState extends State<QuizPertemuanTable> {
  final TextEditingController _namapertemuanController =
      TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  bool _isLoading = false;
  late DatabaseReference _pertemuanRef;
  late DatabaseReference _materialListRef;
  late DatabaseReference _soalQuizListRef;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _namapertemuanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        height: (60 * (widget.pertemuan.length + 1)) + 40,
        child: DataTable2(
          columnSpacing: 12,
          dataRowHeight: 70,
          headingRowHeight: 40,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text("Pertemuan Ke-",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.S,
              // fixedWidth: 115,
            ),
            DataColumn2(
              label: Text('Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Quiz tiap Pertemuan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.S,
              // fixedWidth: 200,
            ),
            DataColumn2(
              label:
                  Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.S,
              // fixedWidth: 150,
            ),
          ],
          rows: List<DataRow>.generate(
            widget.pertemuan.length,
            (index) {
              final pertemuan = widget.pertemuan[index];
              return DataRow(
                cells: [
                  DataCell(Text(pertemuan.namaPertemuan)),
                  DataCell(
                    SingleChildScrollView(
                      // Use a SingleChildScrollView for scrolling
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(pertemuan.description),
                    ),
                  ),
                  DataCell(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D60E2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Text('Detail'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              MultiProvider(
                                  providers: [
                                ChangeNotifierProvider(
                                  create: (context) => Controller(),
                                )
                              ],
                                  child: DashBoardScreen.withIdPertemuan(
                                    contentType: ContentType.ManageListQuiz,
                                    idPertemuan: pertemuan.id,
                                  )),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  )),
                  DataCell(Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6), // <-- Radius
                          ),
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                        ),
                        onPressed: () {
                          _showSimpleModalDialog(context, pertemuan.id,
                              pertemuan.namaPertemuan, pertemuan.description);
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6), // <-- Radius
                          ),
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 16,
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog(pertemuan.id);
                        },
                      ),
                    ],
                  )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSimpleModalDialog(
      context, String pertemuanId, String namaPertemuan, String deskripsi) {
    _namapertemuanController.text = namaPertemuan;
    _deskripsiController.text = deskripsi;
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
                              "Edit Data Pertemuan",
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
                              controller: _namapertemuanController,
                              decoration: InputDecoration(
                                labelText: "Nama Pertemuan",
                                border: OutlineInputBorder(),
                              ),
                              // initialValue: namaPertemuan,
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
                              controller: _deskripsiController,
                              decoration: InputDecoration(
                                labelText: "Deskripsi Pertemuan",
                                border: OutlineInputBorder(),
                              ),
                              // initialValue: deskripsi,
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
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _editPertemuan(pertemuanId);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5D60E2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8), // <-- Radius
                                    ),
                                  ),
                                  icon: _isLoading
                                      ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                      : const SizedBox(),
                                  label: const Text(
                                    'Edit Pertemuan',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
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

  void _editPertemuan(String pertemuanId) {
    DatabaseReference pertemuanRef =
        FirebaseDatabase.instance.ref().child('pertemuan').child(pertemuanId);

    Map<String, dynamic> updatedData = {
      'namaPertemuan': _namapertemuanController.text,
      'description': _deskripsiController.text,
    };

    pertemuanRef.update(updatedData).then((_) {
      print("Pertemuan updated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Pertemuan berhasil diupdate!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
      Navigator.pop(context);
    }).catchError((onError) {
      print("Failed to update pertemuan: $onError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Pertemuan gagal diupdate: $onError'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }

  void _showDeleteConfirmationDialog(String pertemuanId) {
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
                _deletePertemuan(pertemuanId); // Call the function to delete
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

  void _deletePertemuan(String pertemuanId) async {
    _pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan').child(pertemuanId);
    _materialListRef = FirebaseDatabase.instance.ref().child('materialList');
    _soalQuizListRef = FirebaseDatabase.instance.ref().child('soalQuizList');

    // Fetch materialList items with matching idPertemuan using a stream
    _materialListRef.orderByChild('idPertemuan').equalTo(pertemuanId).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> values = event.snapshot.value as Map<String, dynamic>;
        values.forEach((key, value) {
          // Delete each materialList item associated with pertemuanId
          _materialListRef.child(key).remove().then((_) {
            print("MaterialList item deleted successfully!");
          }).catchError((onError) {
            print("Failed to delete materialList item: $onError");
          });
        });
      }
    });

    // Fetch materialList items with matching idPertemuan using a stream
    _soalQuizListRef.orderByChild('idPertemuan').equalTo(pertemuanId).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> values = event.snapshot.value as Map<String, dynamic>;
        values.forEach((key, value) {
          _soalQuizListRef.child(key).remove().then((_) {
            print("soalQuizList item deleted successfully!");
          }).catchError((onError) {
            print("Failed to delete soalQuizList item: $onError");
          });
        });
      }
    });

    // Delete the pertemuan after deleting associated materialList items
    _pertemuanRef.remove().then((_) {
      print("Pertemuan deleted successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Pertemuan berhasil dihapus!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    }).catchError((onError) {
      print("Failed to delete pertemuan: $onError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Pertemuan gagal dihapus: $onError'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }
}
