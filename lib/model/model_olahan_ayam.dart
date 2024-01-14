class ModelAyam {
  int? id;
  String? nama;
  Uri? gambar;
  List<String>? bahan;
  List<String>? langkah;
  String? waktuMasak;
  String? porsi;
  String? tingkatKesulitan;
  late bool isSaved;  // Menggunakan late

  ModelAyam({
    this.id,
    this.nama,
    this.gambar,
    this.bahan,
    this.langkah,
    this.waktuMasak,
    this.porsi,
    this.tingkatKesulitan,
    required bool isSaved, // Pindahkan ke parameter constructor
  }) : isSaved = isSaved;  // Inisialisasi di sini

  ModelAyam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    gambar = Uri.parse(json['gambar']);
    bahan = List<String>.from(json['bahan']);
    langkah = List<String>.from(json['langkah']);
    waktuMasak = json['waktu_masak'];
    porsi = json['porsi'];
    tingkatKesulitan = json['tingkat_kesulitan'];
    isSaved = false; // Diatur ke false saat pertama kali dibuat
  }

  // Metode untuk mengganti status isSaved
  void toggleSavedStatus() {
    isSaved = !isSaved;
  }

  // Metode untuk mengonversi objek menjadi Map untuk penyimpanan lokal
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
