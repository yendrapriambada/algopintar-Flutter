import 'package:flutter/material.dart';
import 'package:algopintar/constants/constants.dart';
import 'package:algopintar/constants/responsive.dart';
import 'package:algopintar/data/data.dart';

import '../../models/analytic_info_model.dart';
import 'analytic_info_card.dart';

class AnalyticCards extends StatelessWidget {
  final int studentCount;
  const AnalyticCards({Key? key, required this.studentCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridView(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
          studentCount: studentCount,
        ),
        tablet: AnalyticInfoCardGridView(),
        desktop: AnalyticInfoCardGridView(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
          studentCount: studentCount,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatelessWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
    this.studentCount = 0,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final int studentCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: appPadding,
      mainAxisSpacing: appPadding,
      childAspectRatio: childAspectRatio,
      //TODO: Change this to dynamic data
      children: <Widget>[
        AnalyticInfoCard(
          info: AnalyticInfo(
            title: "Siswa",
            count: studentCount,
            svgSrc: "assets/icons/Post.svg",
            color: primaryColor,
          ),
        ),
        AnalyticInfoCard(
          info: AnalyticInfo(
            title: "Guru",
            count: 2,
            svgSrc: "assets/icons/Subscribers.svg",
            color: purple,
          ),
        ),
        AnalyticInfoCard(
          info: AnalyticInfo(
            title: "Pertemuan",
            count: 4,
            svgSrc: "assets/icons/Pages.svg",
            color: orange,
          ),
        ),
        AnalyticInfoCard(
          info: AnalyticInfo(
            title: "Telah Selesai Belajar",
            count: 21,
            svgSrc: "assets/icons/Comments.svg",
            color: green,
          ),
        ),
      ]
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GridView.builder(
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: analyticData.length,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: crossAxisCount,
  //       crossAxisSpacing: appPadding,
  //       mainAxisSpacing: appPadding,
  //       childAspectRatio: childAspectRatio,
  //     ),
  //     itemBuilder: (context, index) => AnalyticInfoCard(
  //       info: analyticData[index],
  //     ),
  //   );
  // }
}
