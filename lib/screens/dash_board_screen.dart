import 'package:algopintar/screens/components/list_quiz_table.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/constants/responsive.dart';
import 'package:algopintar/controllers/controller.dart';
import 'package:algopintar/screens/components/dashboard_content.dart';

import 'components/drawer_menu.dart';
import 'package:provider/provider.dart';

import 'components/manage_list_quiz_content.dart';
import 'components/manage_material_content.dart';
import 'components/manage_list_material_content.dart';
import 'components/manage_quiz_content.dart';

enum ContentType {
  Dashboard,
  Material,
  ManageListMaterial,
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
      case ContentType.Material:
        return ManageMaterialContent();
      case ContentType.ManageListMaterial:
        return ManageListMaterialContent(idPertemuan: idPertemuan,);
      case ContentType.Quiz:
        return ManageQuizContent();
      case ContentType.ManageListQuiz:
        return ManageListQuizContent(idPertemuan: idPertemuan,);
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
    );
  }
}
