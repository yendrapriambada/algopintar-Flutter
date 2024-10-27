import 'package:flutter/services.dart';
import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/components/pertemuan_table.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';

class Pertemuan extends StatefulWidget {
  final List<PertemuanModel> pertemuan;

  const Pertemuan({Key? key, required this.pertemuan}) : super(key: key);

  @override
  State<Pertemuan> createState() => _PertemuanState();
}

class _PertemuanState extends State<Pertemuan> {
  late DatabaseReference _pertemuanRef;
  final TextEditingController _namapertemuanController =
      TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _statusPertemuanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _namapertemuanController.dispose();
    _deskripsiController.dispose();
    _statusPertemuanController.dispose();
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
                "Data Pertemuan",
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
                  "Tambah Pertemuan",
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
            child: PertemuanTable(pertemuan: widget.pertemuan),
          )
        ],
      ),
    );
  }

  _showSimpleModalDialog(context) {
    _namapertemuanController.clear();
    _deskripsiController.clear();
    _statusPertemuanController.clear();
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
                              "Tambah Pertemuan",
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Pertemuan Ke- (angka)",
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
                            child: DropdownButtonFormField<String>(
                              value: _statusPertemuanController.text.isNotEmpty
                                  ? _statusPertemuanController.text
                                  : null, // Nilai default untuk dropdown
                              decoration: InputDecoration(
                                labelText: "Status Pertemuan",
                                border: OutlineInputBorder(),
                              ),
                              items: <String>['Aktif', 'Tidak Aktif'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                // Update controller dengan nilai baru dari dropdown
                                _statusPertemuanController.text = newValue!;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a status';
                                }
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
                                      _addPertemuan();
                                    }
                                  },
                                  child: const Text(
                                    'Tambah Pertemuan',
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


  Future<void> _addPertemuan() async {
    String name = _namapertemuanController.text;
    String deskripsi = _deskripsiController.text;
    String statusPertemuan = _statusPertemuanController.text;
    bool boolStatusPertemuan = (statusPertemuan == "Aktif");


    _pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan');
    final snapshot = await _pertemuanRef.orderByChild('namaPertemuan').equalTo(name).get();

    if (snapshot.exists) {
      // print(snapshot.value);
      print("Data Pertemuan ${name} sudah ada");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Pertemuan ${name} sudah ada!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ));
      Navigator.pop(context);
    } else {
      print('No data available.');
      _pertemuanRef.push().set({
        'namaPertemuan': name,
        'description': deskripsi,
        'statusPertemuan': boolStatusPertemuan
      }).then((_) {
        // Data saved successfully!
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Data Pertemuan berhasil ditambah!'),
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
          content: const Text('Data Pertemuan gagal ditambah!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ));
      });
    }
  }
}
