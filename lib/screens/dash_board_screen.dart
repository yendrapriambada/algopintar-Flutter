import 'package:algopintar/screens/components/list_quiz_table.dart';
import 'package:algopintar/screens/components/manage_pertemuan_content.dart';
import 'package:algopintar/screens/components/manage_soal_pemahaman_content.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/constants/responsive.dart';
import 'package:algopintar/controllers/controller.dart';
import 'package:algopintar/screens/components/dashboard_content.dart';

import 'about_screen.dart';
import 'components/drawer_menu.dart';
import 'package:provider/provider.dart';

import 'components/manage_list_quiz_content.dart';
import 'components/manage_material_content.dart';
import 'components/manage_list_material_content.dart';
import 'components/manage_quiz_content.dart';

enum ContentType {
  Dashboard,
  Pertemuan,
  Material,
  ManageListMaterial,
  ManageSoalPemahaman,
  Quiz,
  ManageListQuiz,
}

class DashBoardScreen extends StatelessWidget {
  final ContentType contentType;
  final String idPertemuan;

  // const DashBoardScreen({Key? key, required this.contentType}) : super(key: key);
  // First constructor taking 'contentType' and 'idPertemuan'
  const DashBoardScreen.withIdPertemuan({
    Key? key,
    required this.contentType,
    required this.idPertemuan,
  }) : super(key: key);

  // Named constructor with only 'contentType'
  DashBoardScreen({
    Key? key,
    required this.contentType,
  }) : idPertemuan = '', // Set a default value for idPertemuan if needed
        super(key: key);


  Widget getContentWidget() {
    switch (contentType) {
      case ContentType.Dashboard:
        return DashboardContent();
      case ContentType.Pertemuan:
        return ManagePertemuanContent();
      case ContentType.Material:
        return ManageMaterialContent();
      case ContentType.ManageListMaterial:
        return ManageListMaterialContent(idPertemuan: idPertemuan,);
      case ContentType.Quiz:
        return ManageQuizContent();
      case ContentType.ManageListQuiz:
        return ManageListQuizContent(idPertemuan: idPertemuan,);
      case ContentType.ManageSoalPemahaman:
        return ManageSoalPemahamanContent(idMateri: idPertemuan,);
      default:
        return DashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: DrawerMenu(),
      key: context.read<Controller>().scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: DrawerMenu(),),
            Expanded(
              flex: 5,
              child: getContentWidget(),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
                icon: Icon(Icons.info, color: Color(0xff5D60E2)),
                label: Text(
                  'Tentang aplikasi ini',
                  style: TextStyle(color: Color(0xff5D60E2), fontStyle: FontStyle.italic, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
