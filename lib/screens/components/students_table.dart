import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/style.dart';
import 'package:algopintar/widgets/custom_text.dart';

class StudentsTable extends StatefulWidget {
  final List<Map<dynamic, dynamic>> students;
  const StudentsTable({Key? key, required this.students}) : super(key: key);

  @override
  _StudentsTableState createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {

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
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.deepOrange,
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(student['rating'] != null ? student['rating'].toString() : 'N/A'),
                      ],
                    ),
                  ),
                  DataCell(Container(
                      decoration: BoxDecoration(
                        color: light,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active, width: .5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: CustomText(
                        text: "Detail",
                        color: active.withOpacity(.7),
                        weight: FontWeight.bold,
                      ))),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
