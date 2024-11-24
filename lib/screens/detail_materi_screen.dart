import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/materi_screen.dart';
import 'package:algopintar/screens/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DetailMateri extends StatefulWidget {
  final Map<dynamic, dynamic>? dataPertemuan;
  final String? idPertemuan;

  const DetailMateri(
      {Key? key, required this.dataPertemuan, required this.idPertemuan})
      : super(key: key);

  @override
  State<DetailMateri> createState() => _DetailMateriState();
}

class _DetailMateriState extends State<DetailMateri> {
  late DatabaseReference _materialList;
  List<Map<dynamic, dynamic>> _materials = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<dynamic, dynamic> _subMaterialDone = {};

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _getSubMaterialDoneByUserId();
  }

  Future<void> _initializeDatabase() async {
    // for leaderboard
    await Firebase.initializeApp();
    _materialList = FirebaseDatabase.instance.ref().child('materialList');

    _materialList.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> materialsMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        // print(materialsMap);
        _updateMaterialList(materialsMap);
      }
    });
  }

  void _updateMaterialList(Map<dynamic, dynamic> materialsMap) {
    _materials.clear();
    materialsMap.forEach((key, value) {
      if (value['idPertemuan'] == widget.idPertemuan) {
        Map<String, dynamic> materialWithKey = Map.from(value); // Create a copy of the material
        materialWithKey['idMateri'] = key; // Add the key to the material
        _materials.add(materialWithKey);
      }
    });
    _materials.sort((a, b) => a['urutanMateri'].compareTo(b['urutanMateri']));
    // print("Hasil Akhir: $_materials");
    setState(() {}); // Trigger widget rebuild after updating data
  }

  Future<void> _getSubMaterialDoneByUserId() async {
    User? user = _auth.currentUser;
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('users/${user?.uid}/subMaterialDone');
    starCountRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
      _updateSubMaterialDone(data);
    });
  }

  void _updateSubMaterialDone(Map<dynamic, dynamic>? subMaterialDoneMap) {
    if (mounted) {
      if (subMaterialDoneMap != null) {
        _subMaterialDone.clear();
        subMaterialDoneMap.forEach((key, value) {
          if (value is int) {
            // Assuming value 1 indicates the sub-material is done
            _subMaterialDone[key] = value == 1;
          } else {
            print("Invalid data at key $key: $value");
          }
        });
        print("check sub materi done yaaaaaa: $_subMaterialDone");
        setState(() {}); // Trigger widget rebuild after updating data
      } else {
        print("subMaterialDoneMap is null.");
      }
    } else {
      print("Widget is disposed. Ignoring setState.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return DetailWebPage(
            dataPertemuan: widget.dataPertemuan,
            idPertemuan: widget.idPertemuan,
            materials: _materials,
            subMaterialDone: _subMaterialDone,
          );
        } else {
          return DetailMobilePage(
            dataPertemuan: widget.dataPertemuan,
            idPertemuan: widget.idPertemuan,
            materials: _materials,
            subMaterialDone: _subMaterialDone,
          );
        }
      },
    );
  }
}

class DetailWebPage extends StatelessWidget {
  final Map<dynamic, dynamic>? dataPertemuan;
  final String? idPertemuan;
  final List<Map<dynamic, dynamic>> materials;
  final Map<dynamic, dynamic> subMaterialDone;

  const DetailWebPage(
      {Key? key,
      required this.dataPertemuan,
      required this.idPertemuan,
      required this.materials,
      required this.subMaterialDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Center(
          child: SizedBox(
            width: screenWidth <= 1200 ? 800 : 1200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                            elevation: 4,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Text(
                            'Pertemuan ${dataPertemuan?['namaPertemuan']}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const FavoriteButton()
                        ],
                      ),
                      Center(
                        child: Hero(
                            tag: dataPertemuan?['namaPertemuan'],
                            child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      height: 255,
                                      'images/pertemuan.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      dataPertemuan?['namaPertemuan'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 42.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ])),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 8.0, left: 16.0, right: 16.0),
                        child: Text(
                          dataPertemuan?['description'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const Text(
                            "Sub Materi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 8.0, left: 16.0, right: 16.0),
                            child: materials.isEmpty
                                ? Text(
                                    "Materi tidak ada",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14.0,
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: materials.length,
                                    itemBuilder: (context, index) {
                                      var material = materials[index];
                                      var nextMaterial = index + 1 < materials.length
                                          ? materials[index + 1]
                                          : null;
                                      var subMateriDone = subMaterialDone;
                                      return getListMateri(material, context, nextMaterial, subMateriDone, index);
                                    },
                                  ),
                          ),
                          // Container(
                          //     margin: const EdgeInsets.only(
                          //         top: 24.0,
                          //         left: 16.0,
                          //         right: 16.0,
                          //         bottom: 16.0),
                          //     child: SizedBox(
                          //       width: 250,
                          //       height: 50,
                          //       child: ElevatedButton(
                          //         onPressed: () {
                          //           // Navigator.push(
                          //           //   context,
                          //           //   MaterialPageRoute(
                          //           //     builder: (context) => MateriScreen(
                          //           //         materi: dataPertemuan?['materialList'][0]),
                          //           //   ),
                          //           // );
                          //         },
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: const Color(0xFF5D60E2),
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(
                          //                 12), // <-- Radius
                          //           ),
                          //           // padding: EdgeInsets.all(18),
                          //         ),
                          //         child: const Text(
                          //           'Lanjutkan Belajar',
                          //           textAlign: TextAlign.center,
                          //           style: TextStyle(
                          //             fontFamily: 'Montserrat',
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 14.0,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       ),
                          //     ))

                          Container(
                            margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            child: const Text(
                              'Quiz',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizScreen(
                                          idPertemuan: idPertemuan,
                                          jenisQuiz: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5D60E2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // <-- Radius
                                    ),
                                    padding: EdgeInsets.all(18),
                                  ),
                                  child: const Text(
                                    'Mulai Quiz',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}

class DetailMobilePage extends StatelessWidget {
  final Map<dynamic, dynamic>? dataPertemuan;
  final String? idPertemuan;
  final List<Map<dynamic, dynamic>> materials;
  final Map<dynamic, dynamic> subMaterialDone;

  const DetailMobilePage(
      {Key? key,
      required this.dataPertemuan,
      required this.idPertemuan,
      required this.materials,
      required this.subMaterialDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("test yahh: $subMaterialDone");
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SafeArea(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Hero(
                      tag: dataPertemuan?['namaPertemuan'],
                      child: SizedBox(
                          height: 300,
                          child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Image.asset(
                                    'images/pertemuan.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 32.0),
                                  child: Text(
                                    dataPertemuan?['namaPertemuan'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 41.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17.0),
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      const FavoriteButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Text(
              'Pertemuan ${dataPertemuan?['namaPertemuan']}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Text(
              dataPertemuan?['description'],
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: const Text(
              'Materi',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: materials.isEmpty
                ? Text(
                    "Materi tidak ada",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      var material = materials[index];
                      var nextMaterial = index + 1 < materials.length
                          ? materials[index + 1]
                          : null;
                      var subMateriDone = subMaterialDone;
                      return getListMateri(material, context, nextMaterial, subMateriDone, index);
                    },
                  ),
          ),
          // Container(
          //     margin: const EdgeInsets.only(
          //         top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
          //     child: SizedBox(
          //       width: 1,
          //       height: 50,
          //       child: ElevatedButton(
          //         onPressed: () {
          //           // Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(
          //           //     builder: (context) =>
          //           //         MateriScreen(materi: dataPertemuan?['materialList'][0]),
          //           //   ),
          //           // );
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: const Color(0xFF5D60E2),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12), // <-- Radius
          //           ),
          //           // padding: EdgeInsets.all(18),
          //         ),
          //         child: const Text(
          //           'Lanjutkan Belajar',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontFamily: 'Montserrat',
          //             fontWeight: FontWeight.bold,
          //             fontSize: 14.0,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ))

          Container(
            margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: const Text(
              'Quiz',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          idPertemuan: idPertemuan,
                          jenisQuiz: 1,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D60E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    padding: EdgeInsets.all(18),
                  ),
                  child: const Text(
                    'Mulai Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

Widget getListMateri(Map<dynamic, dynamic>? materi, BuildContext context, Map<dynamic, dynamic>? nextMateri, Map<dynamic, dynamic> subMaterialDone, int index) {
  print(index);
  return Card(
    surfaceTintColor: Colors.white,
    elevation: 3,
    child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
        leading: Icon(Icons.check_circle_rounded, color: subMaterialDone[materi?['idMateri']] == true ? Colors.green : Colors.grey),
        title: Text(
          materi?['namaMateri'],
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14.0,
          ),
        ),
        enabled: index == 0 || subMaterialDone[materi?['idMateri']] == false || subMaterialDone[materi?['idMateri']] == true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MateriScreen(materi: materi, nextMateri: nextMateri),
            ),
          );
        }),
  );
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        elevation: 4,
        child: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ));
  }
}
