import 'package:flutter/material.dart';

class DetailMateri extends StatelessWidget {
  const DetailMateri({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return DetailMobilePage();
        } else {
          return DetailMobilePage();
        }
      },
    );
  }
}

class DetailMobilePage extends StatefulWidget {
  const DetailMobilePage({super.key});

  @override
  State<DetailMobilePage> createState() => _DetailMobilePageState();
}

class _DetailMobilePageState extends State<DetailMobilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            SafeArea(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: "cover materi",
                      child: Container(
                        height: 325,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.asset('images/img_cover_pemilihan.png'),
                        ),
                      )
                    ),
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
              child: const Text(
                'Algoritma Pemilihan',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: const Text(
                'Jenis algoritma yang digunakan untuk memilih satu atau beberapa elemen dari sejumlah elemen yang ada. Pada materi ini, anda akan belajar algoritma pemilihan dengan sub materi sebagai berikut:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
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
      )
    );
  }
}