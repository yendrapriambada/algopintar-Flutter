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
              // Tentang Aplikasi
              Text(
                'PintarInformatika',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Merupakan media dalam pembelajaran mobile yang menyajikan materi informatika dengan cara yang menyenangkan. '
                    'Melalui konsep gamifikasi, belajar informatika jadi lebih seru dan efektif.',
              ),
              SizedBox(height: 16),

              // Kreator
              Text(
                'Kreator',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Abdul Ghani AF (1900232)'),
              Text('Mahasiswa S1 Pendidikan Ilmu Komputer'),
              Text('Universitas Pendidikan Indonesia'),
              SizedBox(height: 16),

              // Daftar Pustaka
              Text(
                'Daftar Pustaka',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. www.geeksforgeeks.org. (2024). “Bubble Sort Algorithm”. [Online]. Diakses pada tanggal 12 Oktober 2024 melalui laman https://www.geeksforgeeks.org/bubble-sort-algorithm/.\n'
                    '2. www.geeksforgeeks.org. (2024). “Selection Sort”. [Online]. Diakses pada tanggal 12 Oktober 2024 melalui laman https://www.geeksforgeeks.org/selection-sort-algorithm-2/.\n'
                    '3. Setiani T. D. (2022). “Kuasai Computational Thinking, Skill Penting Era Digital”. [Online]. Diakses pada tanggal 12 Oktober 2024 melalui laman https://www.dicoding.com/blog/kuasai-computational-thinking-skill-penting-era-digital/.\n'
                    '4. Rozady, M. P., & Koten, Y. P. (2022). Scratch sebagai problem solving computational thinking dalam kurikulum prototipe. Increate-Inovasi dan Kreasi dalam Teknologi Informasi, 8(1), 11-17.\n'
                    '5. Mueller, J., Beckett, D., Hennessey, E., and Shodiev, H. (2017). Assessing computational thinking across the curriculum. Emerging Research, Practice, and Policy on Computational Thinking (pp. 251–267). Springer.',
              ),
              SizedBox(height: 16),

              // Kredit Aset
              Text(
                'Kredit Aset',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _creditsList.isEmpty
                  ? Text('Tidak ada kredit aset ditemukan.')
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
      name: data['name'] ?? 'Unknown',
    );
  }
}
