import 'package:algopintar/models/mata_pelajaran_model.dart';
import 'package:algopintar/screens/materi_screen.dart';
import 'package:flutter/material.dart';

class DetailMateri extends StatelessWidget {
  final Subjects subject;

  const DetailMateri({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return DetailWebPage(
            subject: subject,
          );
        } else {
          return DetailMobilePage(
            subject: subject,
          );
        }
      },
    );
  }
}

class DetailWebPage extends StatelessWidget {
  final Subjects subject;

  const DetailWebPage({Key? key, required this.subject}) : super(key: key);

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
                            subject.name,
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
                            tag: subject.name,
                            child: SizedBox(
                              height: 325,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Image.asset(
                                  subject.imageAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 8.0, left: 16.0, right: 16.0),
                        child: Text(
                          subject.description,
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
                            child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: subject.materialList.length,
                              itemBuilder: (context, index) {
                                final Materi material =
                                    subject.materialList[index];
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MateriScreen(
                                            materi: subject.materialList[0]),
                                      ),
                                    );
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
  final Subjects subject;

  const DetailMobilePage({Key? key, required this.subject}) : super(key: key);

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
                      tag: subject.name,
                      child: SizedBox(
                        height: 325,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.asset(
                            subject.imageAsset,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
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
              subject.name,
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
              subject.description,
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
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subject.materialList.length,
              itemBuilder: (context, index) {
                final Materi material = subject.materialList[index];
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MateriScreen(materi: subject.materialList[0]),
                      ),
                    );
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

Widget getListMateri(Materi materi, BuildContext context) {
  return Card(
    child: ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
        leading: const Icon(Icons.check_circle_rounded, color: Colors.green),
        title: Text(
          materi.title,
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
