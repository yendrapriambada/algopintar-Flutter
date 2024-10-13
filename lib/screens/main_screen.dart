import 'package:algopintar/data/data_static_subjects.dart';
import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/landing_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:algopintar/screens/detail_materi_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/leaderboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String username = 'kawan';
  String email = '';
  int score = 0;
  late DatabaseReference _studentsRef;
  List<Map<dynamic, dynamic>> _students = [];
  int currentPertemuan = 0;
  double currentProgress = 0.0;
  late DatabaseReference _pertemuanRef;
  List<Map<dynamic, dynamic>> _pertemuan = [];

  @override
  void initState() {
    super.initState();
    getCurrentUsername();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await Firebase.initializeApp();
    _studentsRef = FirebaseDatabase.instance.ref('users');
    _pertemuanRef = FirebaseDatabase.instance.ref().child('pertemuan');


    _studentsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> studentsMap =
            event.snapshot.value as Map<dynamic, dynamic>;

        _updateStudentsList(studentsMap);
      }
    });

    _pertemuanRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> pertemuanMap = event.snapshot.value as Map<dynamic, dynamic>;
        _updatePertemuanList(pertemuanMap);
      }
    });
  }

  void _updateStudentsList(Map<dynamic, dynamic> studentsMap) {
    _students.clear();
    studentsMap.forEach((key, value) {
      if (value['role'] == 'student') {
        _students.add(value);
      }
    });
    setState(() {}); // Trigger widget rebuild after updating data
  }

  void _updatePertemuanList(Map<dynamic, dynamic> pertemuanMap) {
    _pertemuan.clear();
    pertemuanMap.forEach((key, value) {
      _pertemuan.add(value);
    });
    setState(() {}); // Trigger widget rebuild after updating data
  }

  Future<void> getCurrentUsername() async {
    User? user = _auth.currentUser;

    if (user?.uid != null) {
      _database.child('users/${user?.uid}').onValue.listen((event) {
        var snapshot = event.snapshot;
        if (snapshot.value != null) {
          var userMap = snapshot.value as Map<dynamic, dynamic>;
          var usernameValue = userMap['username'] as String?;
          var emailValue = userMap['email'] as String?;
          var scoreValue = userMap['score'] as int?;

          if (emailValue != null) {
            setState(() {
              username = usernameValue ?? '';
              email = emailValue ?? '';
              score = scoreValue ?? 0;
            });
          }
        } else {
          print('No data available.');
        }
      });
    } else {
      // Contoh tindakan jika user tidak terautentikasi
      // Misalnya, navigasi ke halaman awal
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    print("username: ${username}");
    print("email: ${email}");
    print("students: ${_students}");
    print("Score: ${score}");
    var progressBelajarList = _students
        .where((element) => element['email'] == email)
        .map((e) => e['progressBelajar'])
        .toList();

    if (progressBelajarList.isNotEmpty) {
      var progressBelajar = progressBelajarList.first + 1;
      print("progressBelajar: $progressBelajar");

      // Jika Anda ingin mengonversi ke tipe data int
      int progressBelajarInt = (progressBelajar?.toDouble() ?? 0).toInt();
      print("progressBelajar (as int): $progressBelajarInt");

      // Selanjutnya, Anda dapat melanjutkan dengan perhitungan currentPertemuan dan currentProgress
      currentPertemuan = (progressBelajarInt / 100).toInt() + 1;
      currentProgress = (progressBelajarInt / 100 - (currentPertemuan - 1));

      print("currentPertemuan: $currentPertemuan");
      print("currentProgress: ${currentProgress}");
    } else {
      print("Data tidak ditemukan untuk email yang diberikan");
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return HomepageWeb(
              username: username,
              score: score,
              students: _students,
              currentPertemuan: currentPertemuan,
              currentProgress: currentProgress,
              pertemuanLength: _pertemuan.length
          );
        } else {
          return HomepageMobile(
              username: username,
              score: score,
              students: _students,
              currentPertemuan: currentPertemuan,
              currentProgress: currentProgress,
              pertemuanLength: _pertemuan.length);
        }
      },
    );
  }
}

class HomepageWeb extends StatefulWidget {
  final String username;
  final int score;
  final List<Map<dynamic, dynamic>> students;
  final int currentPertemuan;
  final double currentProgress;
  final int pertemuanLength;

  const HomepageWeb(
      {Key? key,
      required this.username,
      required this.score,
      required this.students,
      required this.currentPertemuan,
      required this.currentProgress,
      required this.pertemuanLength})
      : super(key: key);

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
                              ClipRRect(
                                child: Image.network(
                                  'https://api.dicebear.com/7.x/adventurer/png?seed=${widget.username}&backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf',
                                  height: 55,
                                  width: 55,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(30),
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
                                surfaceTintColor: Colors.white,
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
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            color: Color(0xff5D60E2),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text(
                                                "Skor: ${widget.score}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      widget.currentPertemuan > widget.pertemuanLength ?
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Selamat anda telah menyelesaikan seluruh materi! 👍",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ) :
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Hero(
                                                tag:
                                                    '${widget.currentPertemuan}-w',
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.asset(
                                                          'images/pertemuan.png',
                                                          fit: BoxFit.cover,
                                                          width: 80,
                                                          height: 80,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Text(
                                                          '${widget.currentPertemuan}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 22.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ])),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Pertemuan ${widget.currentPertemuan}",
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
                                                        value: widget
                                                            .currentProgress,
                                                        color: Colors.green,
                                                        backgroundColor:
                                                            Colors.orangeAccent,
                                                      )),
                                                      SizedBox(width: 8),
                                                      Center(
                                                        // this widget is not nessesary
                                                        child: Text(
                                                          '${(widget.currentProgress * 100).toInt()}%',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                            margin: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 8.0),
                            child: SizedBox(
                              height: 372,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Leaderboard(
                                  students: widget.students,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              const Text(
                                "Pertemuan",
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
                                        child: FirebaseAnimatedList(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            query: FirebaseDatabase.instance
                                                .ref('pertemuan'),
                                            itemBuilder: (context, snapshot,
                                                animation, index) {
                                              Map<dynamic, dynamic>?
                                                  dataPertemuan = snapshot.value
                                                      as Map<dynamic, dynamic>?;
                                              var idPertemuan = snapshot.key;

                                              return Card(
                                                surfaceTintColor: Colors.white,
                                                elevation: 3,
                                                child: ListTile(
                                                  visualDensity: VisualDensity(
                                                      horizontal: 3,
                                                      vertical: 3),
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            bottom: 6.0),
                                                    child: Hero(
                                                        tag: dataPertemuan?[
                                                            'namaPertemuan'],
                                                        child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: <Widget>[
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child:
                                                                    Image.asset(
                                                                  'images/pertemuan.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                  dataPertemuan?[
                                                                      'namaPertemuan'],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ])),
                                                  ),
                                                  title: Text(
                                                      'Pertemuan ${dataPertemuan?['namaPertemuan'] as String}'),
                                                  // subtitle: Text('4 Sub Materi'),
                                                  enabled: dataPertemuan?['statusPertemuan'] == true &&
                                                      int.parse(dataPertemuan?['namaPertemuan']) <= widget.currentPertemuan
                                                      ? true
                                                      : false,
                                                  trailing:
                                                      Icon(Icons.navigate_next),
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return DetailMateri(
                                                        dataPertemuan:
                                                            dataPertemuan,
                                                        idPertemuan:
                                                            idPertemuan,
                                                      );
                                                    }));
                                                  },
                                                ),
                                              );
                                            })),
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
  final int score;
  final List<Map<dynamic, dynamic>> students;
  final int currentPertemuan;
  final double currentProgress;
  final int pertemuanLength;

  const HomepageMobile(
      {Key? key,
      required this.username,
      required this.score,
      required this.students,
      required this.currentPertemuan,
      required this.currentProgress,
      required this.pertemuanLength})
      : super(key: key);

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
                      ClipRRect(
                        child: Image.network(
                          'https://api.dicebear.com/7.x/adventurer/png?seed=${widget.username}&backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf',
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        surfaceTintColor: Colors.white,
                        elevation: 3,
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
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: Color(0xff5D60E2),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Skor: ${widget.score}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        widget.currentPertemuan > widget.pertemuanLength ?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Selamat anda telah menyelesaikan seluruh materi! 👍",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ):
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Hero(
                                  tag: '${widget.currentPertemuan}-m',
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          child: Image.asset(
                                            'images/pertemuan.png',
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '${widget.currentPertemuan}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 22.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ])),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Pertemuan ${widget.currentPertemuan}",
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
                                              value: widget.currentProgress,
                                              color: Colors.green,
                                              backgroundColor: Colors.orangeAccent,
                                            )),
                                        SizedBox(width: 8),
                                        Center(
                                          // this widget is not nessesary
                                          child: Text(
                                            '${(widget.currentProgress * 100).toInt()}%',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
              child: const Text(
                "Pertemuan",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
              child: SizedBox(
                  height: 280.0,
                  child: FirebaseAnimatedList(
                      padding: const EdgeInsets.only(top: 0),
                      query: FirebaseDatabase.instance.ref('pertemuan'),
                      itemBuilder: (context, snapshot, animation, index) {
                        Map<dynamic, dynamic>? dataPertemuan =
                            snapshot.value as Map<dynamic, dynamic>?;
                        var idPertemuan = snapshot.key;

                        return Card(
                          surfaceTintColor: Colors.white,
                          elevation: 2,
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 3, vertical: 3),
                            leading: Padding(
                              padding:
                                  const EdgeInsets.only(top: 6.0, bottom: 6.0),
                              child: Hero(
                                  tag: dataPertemuan?['namaPertemuan'],
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.asset(
                                            'images/pertemuan.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            dataPertemuan?['namaPertemuan'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ])),
                            ),
                            title: Text(
                                'Pertemuan ${dataPertemuan?['namaPertemuan'] as String}'),
                            // subtitle: Text('4 Sub Materi'),
                            enabled: dataPertemuan?['statusPertemuan'] == true &&
                                int.parse(dataPertemuan?['namaPertemuan']) <= widget.currentPertemuan
                                    ? true
                                    : false,
                            trailing: Icon(Icons.navigate_next),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailMateri(
                                    dataPertemuan: dataPertemuan,
                                    idPertemuan: idPertemuan);
                              }));
                            },
                          ),
                        );
                      })),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: SizedBox(
                height: 350,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Leaderboard(
                    students: widget.students,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
