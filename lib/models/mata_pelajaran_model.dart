class PertemuanModel {
  String id;
  String namaPertemuan;
  String description;
  bool statusPertemuan;

  // Add other fields as needed

  PertemuanModel(
      {required this.id,
      required this.namaPertemuan,
      required this.description,
      required this.statusPertemuan
      // Add other fields here
      });

  factory PertemuanModel.fromJson(Map<String, dynamic> json, String id) {
    return PertemuanModel(
        id: id,
        namaPertemuan: json['namaPertemuan'] ?? '',
        description: json['description'] ?? '',
        statusPertemuan: json['statusPertemuan'] ?? false
        // Parse other fields accordingly
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaPertemuan': namaPertemuan,
      'description': description,
      'statusPertemuan': statusPertemuan
      // Add other fields accordingly
    };
  }
}

class MateriModel {
  final String id; // ID materi
  final String urutanMateri;
  final String namaMateri; // Nama materi
  final String linkPdf; // URL ke file PDF
  final String linkYoutube; // URL ke Youtube
  final String idPertemuan; // ID pertemuan

  MateriModel({
    required this.id,
    required this.urutanMateri,
    required this.namaMateri,
    required this.linkPdf,
    required this.linkYoutube,
    required this.idPertemuan,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json, String id) {
    return MateriModel(
      id: id,
      urutanMateri: json['urutanMateri'] ?? '',
      namaMateri: json['namaMateri'] ?? '',
      linkPdf: json['linkPdf'] ?? '',
      linkYoutube: json['linkYoutube'] ?? '',
      idPertemuan: json['idPertemuan'] ?? '',
      // Parse other fields accordingly
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urutanMateri': urutanMateri,
      'namaMateri': namaMateri,
      'linkPdf': linkPdf,
      'linkYoutube': linkYoutube,
      'idPertemuan': idPertemuan,
    };
  }
}

class Quizmodel {
  final String id;
  final String nomorSoal;
  final String soal;
  final String pilganA;
  final String pilganB;
  final String pilganC;
  final String pilganD;
  final String pilganE;
  final String kunciJawaban;
  final String idPertemuan; // ID pertemuan

  Quizmodel({
    required this.id,
    required this.nomorSoal,
    required this.soal,
    required this.pilganA,
    required this.pilganB,
    required this.pilganC,
    required this.pilganD,
    required this.pilganE,
    required this.kunciJawaban,
    required this.idPertemuan,
  });

  factory Quizmodel.fromJson(Map<String, dynamic> json, String id) {
    return Quizmodel(
      id: id,
      nomorSoal: json['nomorSoal'] ?? '',
      soal: json['soal'] ?? '',
      pilganA: json['pilganA'] ?? '',
      pilganB: json['pilganB'] ?? '',
      pilganC: json['pilganC'] ?? '',
      pilganD: json['pilganD'] ?? '',
      pilganE: json['pilganE'] ?? '',
      kunciJawaban: json['kunciJawaban'] ?? '',
      idPertemuan: json['idPertemuan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomorSoal': nomorSoal,
      'soal': soal,
      'pilganA': pilganA,
      'pilganB': pilganB,
      'pilganC': pilganC,
      'pilganD': pilganD,
      'pilganE': pilganE,
      'kunciJawaban': kunciJawaban,
      'idPertemuan': idPertemuan,
    };
  }
}
