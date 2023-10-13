import 'package:algopintar/model/mata_pelajaran.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/detail_materi.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            // return Leaderboard();
            return HomepageMobile();
          }
          else {
            // return Leaderboard();
            return HomepageMobile();
            // return HomepageWeb();
          }
        },
    );
  }
}

class HomepageMobile extends StatelessWidget {

  const HomepageMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/default_profilepic.png'),
                      radius: 30,
                    ),
                    Image.asset('images/ic_menu.png', width: 70, height: 70),
                  ],
                )
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                "Halo, Ghani!",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat', // Use the font family name specified in pubspec.yaml
                  fontWeight: FontWeight.bold, // Set the fontWeight to bold
                  fontSize: 20, // Set the font size as needed
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: const Text(
                "Selamat Datang di AlgoPintar 👋",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Progress Belajar",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Hero(
                              tag: "cover_pemilihan",
                              child: Image.asset('images/img_cover_pemilihan.png'),
                            ),
                          ),
                          SizedBox(width: 8),
                          const Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Algoritma Pemilihan",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: 0.7,
                                          color: Colors.green,
                                          backgroundColor: Colors.orangeAccent,
                                        )
                                      ),
                                      SizedBox(width: 8),
                                      Center( // this widget is not nessesary
                                        child: Text(
                                          '70%',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // LinearProgressIndicator(
                                  //   value: 0.7,
                                  //   color: Colors.green,
                                  //   backgroundColor: Colors.orangeAccent,
                                  // ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
              child: const Text(
                "Materi",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: SizedBox(
                height: 250.0,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final Subjects subject = subjectsList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return DetailMateri(subject: subject);
                        }));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Hero(
                                tag: subject.name,
                                child: Image.asset(subject.imageAsset, fit: BoxFit.cover,),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                              child: Text(
                                subject.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                              child: Text(
                                subject.numOfSubs,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: subjectsList.length,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: const Text(
                "Papan Peringkat",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text(
                      'ID',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  )),
                  DataColumn(label: Text(
                      'Name',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  )),
                  DataColumn(label: Text(
                      'Score',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  )),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('1')),
                    DataCell(Text('Stephen')),
                    DataCell(Text('100')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('2')),
                    DataCell(Text('John')),
                    DataCell(Text('90')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('3')),
                    DataCell(Text('Harry')),
                    DataCell(Text('80')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('4')),
                    DataCell(Text('Peter')),
                    DataCell(Text('75')),
                  ]),
                ],
              ),
            ),








          ],
        ),
      ),
    );
  }
}
