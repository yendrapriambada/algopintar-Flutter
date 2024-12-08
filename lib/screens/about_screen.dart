import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final DatabaseReference _creditsRef = FirebaseDatabase.instance.ref('credits');
  List<Credit> _creditsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCredits();
  }

  void _fetchCredits() async {
    _creditsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _creditsList = data.entries
              .map((e) => Credit.fromMap(e.key, e.value as Map<dynamic, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _creditsList = [];
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6200EE),
        title: Center(child: Text('Tentang')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Creator
              Text(
                'Kreator',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Nama: Abdul Ghani'),
              Text('Jurusan: Pendidikan Ilmu Komputer'),
              Text('Kampus: Universitas Pendidikan Indonesia'),
              SizedBox(height: 16),

              // Section Credits
              Text(
                'Kredit Aset',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _creditsList.isEmpty
                  ? Text('Tidak ada credit asset ditemukan.')
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _creditsList.length,
                itemBuilder: (context, index) {
                  final credit = _creditsList[index];
                  return ListTile(
                    title: Text("• ${credit.name}"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Credit {
  final String id;
  final String name;

  Credit({required this.id, required this.name});

  factory Credit.fromMap(String id, Map<dynamic, dynamic> data) {
    return Credit(
      id: id,
      name: data['name'] ?? 'Unknown', // Mengambil field 'name' dari data Firebase
    );
  }
}
