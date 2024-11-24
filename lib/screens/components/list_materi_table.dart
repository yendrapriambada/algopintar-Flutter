import 'package:algopintar/screens/components/dashboard_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../controllers/controller.dart';
import '../../models/mata_pelajaran_model.dart';
import '../dash_board_screen.dart';
import 'manage_soal_pemahaman_content.dart';

class ListMateriTable extends StatefulWidget {
  final List<MateriModel> listMateri;
  final String idPertemuan;

  const ListMateriTable({Key? key, required this.listMateri, required this.idPertemuan}) : super(key: key);

  @override
  _ListMateriTableState createState() => _ListMateriTableState();
}

class _ListMateriTableState extends State<ListMateriTable> {
  late DatabaseReference _listMateriRef;
  final TextEditingController _urutanMateriController = TextEditingController();
  final TextEditingController _namaMateriController = TextEditingController();
  final TextEditingController _linkPDFController = TextEditingController();
  final TextEditingController _linkYoutubeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _urutanMateriController.dispose();
    _namaMateriController.dispose();
    _linkPDFController.dispose();
    _linkYoutubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        height: (60 * (widget.listMateri.length + 1)) + 40,
        child: DataTable2(
          columnSpacing: 12,
          dataRowHeight: 70,
          headingRowHeight: 40,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text("Urutan Materi",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.S,
              // fixedWidth: 115,
            ),
            DataColumn2(
              label: Text('Nama Materi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Link Pdf',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.S,
              // fixedWidth: 200,
            ),
            DataColumn2(
              label: Text('Link Youtube',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // size: ColumnSize.S,
              // fixedWidth: 200,
            ),
            DataColumn2(
              label: Text('Detail Soal Pemahaman',
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
            widget.listMateri.length,
            (index) {
              final materi = widget.listMateri[index];
              return DataRow(
                cells: [
                  DataCell(Text(materi.urutanMateri)),
                  DataCell(Text(materi.namaMateri)),
                  DataCell(Text(materi.linkPdf)),
                  DataCell(Text(materi.linkYoutube)),
                  DataCell(ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D60E2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Text('Detail', style: TextStyle(color: Colors.white)),
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
                                    contentType: ContentType.ManageSoalPemahaman,
                                    idPertemuan: materi.id,
                                  )),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  )),
                  DataCell(Row(
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Icon(Icons.edit, size: 16),
                          onPressed: () {
                            _showSimpleModalDialog(
                                context, materi.id, materi.urutanMateri, materi.namaMateri, materi.linkPdf, materi.linkYoutube);
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Icon(Icons.delete, size: 16),
                          onPressed: () {
                            _showDeleteConfirmationDialog(materi.id);
                          },
                        ),
                      ),
                    ],
                  ))

                  // DataCell(Row(
                  //   children: [
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
                  //             materi.id,
                  //             materi.urutanMateri,
                  //             materi.namaMateri,
                  //             materi.linkPdf,
                  //             materi.linkYoutube);
                  //       },
                  //     ),
                  //     SizedBox(
                  //       width: 8,
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
                  //         _showDeleteConfirmationDialog(materi.id);
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

  _showSimpleModalDialog(context, String materiId, String urutanMateri,
      String namaMateri, String linkPdf, String linkYoutube) {
    _urutanMateriController.text = urutanMateri;
    _namaMateriController.text = namaMateri;
    _linkPDFController.text = linkPdf;
    _linkYoutubeController.text = linkYoutube;

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
                              "Edit Data Materi",
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
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              controller: _linkYoutubeController,
                              decoration: InputDecoration(
                                labelText: "Link Youtube",
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
                                      _editMateri(materiId);
                                    }
                                  },
                                  child: const Text(
                                    'Edit Materi',
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

  void _editMateri(String materiId) {
    DatabaseReference pertemuanRef =
        FirebaseDatabase.instance.ref().child('materialList').child(materiId);

    Map<String, dynamic> updatedData = {
      'urutanMateri': _urutanMateriController.text,
      'namaMateri': _namaMateriController.text,
      'linkPdf': _linkPDFController.text,
      'linkYoutube': _linkYoutubeController.text,
    };

    pertemuanRef.update(updatedData).then((_) {
      print("Materi updated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Materi berhasil diupdate!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
      Navigator.pop(context);
    }).catchError((onError) {
      print("Failed to update Materi: $onError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Materi gagal diupdate: $onError'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    });
  }

  void _showDeleteConfirmationDialog(String materiId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi hapus data'),
          content: Text('Apakah kamu yakin ingin menghapus data ini?\avg bobot materi setelah delete: ${100 / (widget.listMateri.length - 1)}'),
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
                _deleteMateri(materiId); // Call the function to delete
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

  void _deleteMateri(String materiId) async {
    double bobotMateri = 100 / (widget.listMateri.length - 1);

    _listMateriRef =
        FirebaseDatabase.instance.ref().child('materialList').child(materiId);

    _listMateriRef.remove().then((_) {
      print("Materi deleted successfully!");
      _updateBobotMateriBulk(bobotMateri);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data Materi berhasil dihapus!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
    }).catchError((onError) {
      print("Failed to delete Materi: $onError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Materi gagal dihapus: $onError'),
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
