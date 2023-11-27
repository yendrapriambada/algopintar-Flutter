class PertemuanModel {
  String id;
  String namaPertemuan;
  String description;
  // Add other fields as needed

  PertemuanModel({
    required this.id,
    required this.namaPertemuan,
    required this.description,
    // Add other fields here
  });

  factory PertemuanModel.fromJson(Map<String, dynamic> json, String id) {
    return PertemuanModel(
      id: id,
      namaPertemuan: json['namaPertemuan'] ?? '',
      description: json['description'] ?? '',
      // Parse other fields accordingly
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaPertemuan': namaPertemuan,
      'description': description,
      // Add other fields accordingly
    };
  }
}


class MateriModel {
  final String id; // ID materi
  final String urutanMateri;
  final String namaMateri;  // Nama materi
  final String linkPdf; // URL ke file PDF
  final String idPertemuan; // ID pertemuan

  MateriModel({
    required this.id,
    required this.urutanMateri,
    required this.namaMateri,
    required this.linkPdf,
    required this.idPertemuan,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json, String id) {
    return MateriModel(
      id: id,
      urutanMateri: json['urutanMateri'] ?? '',
      namaMateri: json['namaMateri'] ?? '',
      linkPdf: json['linkPdf'] ?? '',
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
      'idPertemuan': idPertemuan,
    };
  }
}
