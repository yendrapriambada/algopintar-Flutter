class Subjects {
  String name;
  String numOfSubs;
  String description;
  String imageAsset;
  List<Materi> materialList;

  Subjects({
    required this.name,
    required this.numOfSubs,
    required this.description,
    required this.imageAsset,
    required this.materialList,
  });
}

class Materi {
  final String title;  // Nama materi
  final String pdfUrl; // URL ke file PDF

  Materi({
    required this.title,
    required this.pdfUrl,
  });
}
