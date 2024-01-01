import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/materi_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
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
      print(value);
      if (value['idPertemuan'] == widget.idPertemuan) {
        _materials.add(value);
      }
    });
    _materials.sort((a, b) => a['urutanMateri'].compareTo(b['urutanMateri']));
    setState(() {}); // Trigger widget rebuild after updating data
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
          );
        } else {
          return DetailMobilePage(
            dataPertemuan: widget.dataPertemuan,
            idPertemuan: widget.idPertemuan,
            materials: _materials,
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

  const DetailWebPage(
      {Key? key,
      required this.dataPertemuan,
      required this.idPertemuan,
      required this.materials})
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
                                      return getListMateri(material, context);
                                    },
                                  ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 24.0,
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 16.0),
                              child: SizedBox(
                                width: 250,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => MateriScreen(
                                    //         materi: dataPertemuan?['materialList'][0]),
                                    //   ),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5D60E2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ),
                                    // padding: EdgeInsets.all(18),
                                  ),
                                  child: const Text(
                                    'Lanjutkan Belajar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ))
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

  const DetailMobilePage(
      {Key? key,
      required this.dataPertemuan,
      required this.idPertemuan,
      required this.materials})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      return getListMateri(material, context);
                    },
                  ),
          ),
          Container(
              margin: const EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
              child: SizedBox(
                width: 1,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         MateriScreen(materi: dataPertemuan?['materialList'][0]),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D60E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    // padding: EdgeInsets.all(18),
                  ),
                  child: const Text(
                    'Lanjutkan Belajar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ))
        ],
      )),
    );
  }
}

Widget getListMateri(Map<dynamic, dynamic>? materi, BuildContext context) {
  return Card(
    child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
        leading: const Icon(Icons.check_circle_rounded, color: Colors.green),
        title: Text(
          materi?['namaMateri'],
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14.0,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MateriScreen(materi: materi),
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
