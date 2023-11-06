import 'package:algopintar/data/data_static_subjects.dart';
import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/landing_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/screens/detail_materi_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String username = 'kawan';

  @override
  void initState() {
    super.initState();
    getCurrentUsername();
  }

  Future<void> getCurrentUsername() async {
    User? user = _auth.currentUser;

    if (user?.uid != null) {
      final snapshot = await _database.child('users/${user?.uid}').get();
      if (snapshot.exists) {
        var userMap = snapshot.value as Map<dynamic, dynamic>?;
        var usernameValue = userMap?['username'] as String?;

        if (usernameValue != null) {
          setState(() {
            username = usernameValue;
          });
        }
      } else {
        print('No data available.');
      }
    } else {
      const LandingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return HomepageWeb(username: username);
        } else {
          return HomepageMobile(username: username);
        }
      },
    );
  }
}

class HomepageWeb extends StatefulWidget {
  final String username;
  const HomepageWeb({Key? key, required this.username}) : super(key: key);

  @override
  State<HomepageWeb> createState() => _HomepageWebState();
}

class _HomepageWebState extends State<HomepageWeb> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Center(
          child: SizedBox(
            width: screenWidth <= 1200 ? 900 : 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/default_profilepic.png'),
                                radius: 30,
                              ),
                              // screenWidth <= 1200
                              //     ? const SizedBox()
                              //     :
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      "Halo, ${widget.username}!",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        // Use the font family name specified in pubspec.yaml
                                        fontWeight: FontWeight.bold,
                                        // Set the fontWeight to bold
                                        fontSize:
                                            20, // Set the font size as needed
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8.0, left: 16.0),
                                    child: const Text(
                                      "Selamat Datang di AlgoPintar 👋",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.0),
                                ),
                                elevation: 4,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    FirebaseAuth.instance.signOut();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove('userId');
                                    prefs.remove('username');
                                    Navigator.pushNamed(
                                        context, "/landingPage");
                                  },
                                ),
                              ),
                            ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Hero(
                                              tag: "cover_pemilihan",
                                              child: Image.asset(
                                                  'images/img_cover_pemilihan.png'),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          child:
                                                              LinearProgressIndicator(
                                                        value: 0.7,
                                                        color: Colors.green,
                                                        backgroundColor:
                                                            Colors.orangeAccent,
                                                      )),
                                                      SizedBox(width: 8),
                                                      Center(
                                                        // this widget is not nessesary
                                                        child: Text(
                                                          '70%',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
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
                                  )),
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
                            margin: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 8.0),
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                    label: Text('ID',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Score',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: const [
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
                    const SizedBox(width: 32),
                    Expanded(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const Text(
                                "Mata Pelajaran",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 500,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final Subjects subject =
                                              subjectsList[index];
                                          return InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return DetailMateri(
                                                      subject: subject);
                                                }));
                                              },
                                              child: ListTile(
                                                leading: Hero(
                                                  tag: subject.name,
                                                  child: Image.asset(
                                                    subject.imageAsset,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                title: Text(
                                                  subject.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  subject.numOfSubs,
                                                  style: const TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ));
                                        },
                                        itemCount: subjectsList.length,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class HomepageMobile extends StatefulWidget {
  final String username;
  const HomepageMobile({required this.username, Key? key}) : super(key: key);


  @override
  State<HomepageMobile> createState() => _HomepageMobileState();
}

class _HomepageMobileState extends State<HomepageMobile> {
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
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('images/default_profilepic.png'),
                        radius: 30,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        elevation: 4,
                        child: IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // prefs.remove('userId');
                            // prefs.remove('username');
                            Navigator.pushNamed(context, "/landingPage");
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Halo, ${widget.username}!",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  // Use the font family name specified in pubspec.yaml
                  fontWeight: FontWeight.bold,
                  // Set the fontWeight to bold
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
                                child: Image.asset(
                                    'images/img_cover_pemilihan.png'),
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                        )),
                                        SizedBox(width: 8),
                                        Center(
                                          // this widget is not nessesary
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
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
              child: const Text(
                "Mata Pelajaran",
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
                                child: Image.asset(
                                  subject.imageAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 4.0),
                              child: Text(
                                subject.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 10.0),
                              child: Text(
                                subject.numOfSubs,
                                style: const TextStyle(
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
                columns: const [
                  DataColumn(
                      label: Text('ID',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Score',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
                rows: const [
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
