import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/style.dart';
import 'package:algopintar/widgets/custom_text.dart';

class StudentsTable extends StatefulWidget {
  final List<Map<dynamic, dynamic>> students;
  final int materiCount;
  const StudentsTable({Key? key, required this.students, required this.materiCount}) : super(key: key);

  @override
  _StudentsTableState createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  // Fungsi untuk mengirim email reset password
  Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset password email sent to $email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset password email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        height: (60 * (widget.students.length + 1)) + 40,
        child: DataTable2(
          columnSpacing: 12,
          dataRowHeight: 60,
          headingRowHeight: 40,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text('Progres', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
              size: ColumnSize.S,
            ),
          ],

          rows: List<DataRow>.generate(
            widget.students.length,
                (index) {
              final student = widget.students[index];
              return DataRow(
                cells: [
                  DataCell(Text(student['email'] ?? 'N/A')),
                  DataCell(Text(student['fullName'] ?? 'N/A')),
                  DataCell(Text(student['username'] ?? 'N/A')),
                  DataCell(Text(
                      (student['subMaterialDone'] is Map)
                          ? ((student['subMaterialDone'].keys.length / widget.materiCount) * 100).toStringAsFixed(1) + '%'  // Menampilkan persentase dengan 1 angka desimal
                          : '0%'  // Jika subMaterialDone bukan Map, tampilkan 0%
                  ),),

                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.restore, color: Colors.blue),
                          onPressed: () {
                            // Kirim reset password berdasarkan email siswa
                            sendPasswordResetEmail(student['email'], context);
                          },
                          tooltip: 'Reset Password',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
