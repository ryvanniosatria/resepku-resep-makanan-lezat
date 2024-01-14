class ModelDaging {
  int? id;
  String? nama;
  Uri? gambar;
  List<String>? bahan;
  List<String>? langkah;
  String? waktuMasak;
  String? porsi;
  String? tingkatKesulitan;
  late bool isSaved; // Gunakan late untuk memberi tahu Dart

  ModelDaging({
    this.id,
    this.nama,
    this.gambar,
    this.bahan,
    this.langkah,
    this.waktuMasak,
    this.porsi,
    this.tingkatKesulitan,
    required this.isSaved,
  });

  ModelDaging.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    gambar = Uri.parse(json['gambar']);
    bahan = List<String>.from(json['bahan']);
    langkah = List<String>.from(json['langkah']);
    waktuMasak = json['waktu_masak'];
    porsi = json['porsi'];
    tingkatKesulitan = json['tingkat_kesulitan'];
    isSaved = false;
  }

  // Metode untuk mengganti status isSaved
  void toggleSavedStatus() {
    isSaved = !isSaved;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'gambar': gambar.toString(),
      'bahan': bahan,
      'langkah': langkah,
      'waktu_masak': waktuMasak,
      'porsi': porsi,
      'tingkat_kesulitan': tingkatKesulitan,
    };
  }
}
