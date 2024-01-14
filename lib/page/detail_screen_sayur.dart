// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:resep_makanan/model/model_olahan_sayur.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class DetailScreenSayur extends StatefulWidget {
  final ModelSayur sayur;

  const DetailScreenSayur({Key? key, required this.sayur}) : super(key: key);

  @override
  _DetailScreenSayurState createState() => _DetailScreenSayurState();
}

class _DetailScreenSayurState extends State<DetailScreenSayur> {
  // Flag untuk menentukan apakah resep sudah disimpan atau tidak
  bool isResepDisimpan = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah resep sudah disimpan saat inisialisasi
    cekResepDisimpan();
  }

  Future<void> showCustomSnackBar(String message) async {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 91, 91, 91),
      elevation: 6.0,
      action: SnackBarAction(
        label: 'Tutup',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

    Future<void> shareResep(ModelSayur resep) async {
    // Membuat pesan yang akan dibagikan ke WhatsApp
    String message = 'Hai, saya ingin berbagi resep ${resep.nama}:\n\n';
    message += 'Waktu Masak: ${resep.waktuMasak}\n';
    message += 'Porsi: ${resep.porsi}\n';
    message += 'Tingkat Kesulitan: ${resep.tingkatKesulitan}\n\n';
    message +=
        'Bahan-bahan:\n${resep.bahan?.map((bahan) => "- $bahan").join('\n')}\n\n';
    message +=
        'Langkah-langkah:\n${resep.langkah?.map((langkah) => "${resep.langkah!.indexOf(langkah) + 1}. $langkah").join('\n')}\n\n';
    message += 'Dibagikan melalui Resepku App';

    // Format nomor WhatsApp tujuan
    String phoneNumber =
        '6281298791807'; // Ganti dengan nomor WhatsApp yang dituju

    // Buat URL dengan format wa.me/<nomor WhatsApp>?text=<pesan>
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    // Buka URL menggunakan url_launcher
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> simpanResep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar resep yang sudah ada di penyimpanan lokal
    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Konversi objek Resep menjadi JSON
    String resepJson = jsonEncode(widget.sayur.toJson());

    // Cek apakah resep sudah ada di daftar resep yang disimpan
    bool isDisimpan = daftarResepString.contains(resepJson);

    if (isDisimpan) {
      // Jika resep sudah disimpan, hapus dari daftar yang disimpan
      daftarResepString.remove(resepJson);
    } else {
      // Jika resep belum disimpan, tambahkan ke daftar yang disimpan
      daftarResepString.add(resepJson);
    }

    // Simpan kembali daftar resep ke penyimpanan lokal
    prefs.setStringList('daftarResep', daftarResepString);

    // Set flag berdasarkan apakah resep sudah disimpan atau tidak
    setState(() {
      widget.sayur.toggleSavedStatus(); // Perbarui status isSaved
    });
    await showCustomSnackBar('Resep ${widget.sayur.nama} telah disimpan');
    // Tambahkan pesan log atau penanganan lain yang diperlukan
    print(
        'Resep ${widget.sayur.isSaved ? "disimpan" : "dihapus"}: ${widget.sayur.nama}');
  }

  // Fungsi untuk cek apakah resep sudah disimpan atau tidak
  Future<void> cekResepDisimpan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Cek apakah resep sudah ada di daftar resep yang disimpan
    String resepJson = jsonEncode(widget.sayur.toJson());
    bool isDisimpan = daftarResepString.contains(resepJson);

    setState(() {
      isResepDisimpan = isDisimpan;
    });
  }

  // Fungsi untuk menghapus resep
  Future<void> hapusResep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar resep yang sudah ada di penyimpanan lokal
    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Konversi objek Resep menjadi JSON
    String resepJson = jsonEncode(widget.sayur.toJson());

    // Hapus JSON resep dari daftar resep
    daftarResepString.remove(resepJson);

    // Simpan daftar resep kembali ke penyimpanan lokal
    prefs.setStringList('daftarResep', daftarResepString);

    // Set flag bahwa resep tidak disimpan
    setState(() {
      isResepDisimpan = false;
    });
    await showCustomSnackBar('Resep ${widget.sayur.nama} telah dihapus');
    // Tambahkan pesan log atau penanganan lain yang diperlukan
    print('Resep dihapus dari penyimpanan: ${widget.sayur.nama}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/images/icon.png",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 8),
            Text(
              widget.sayur.nama!,
              style: TextStyle(
                fontSize: 17.5,
                fontFamily: 'Poppins-SemiBold',
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black, size: 20),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              shareResep(widget.sayur);
            },
          ),
          // Tambahkan ikon Simpan di AppBar
          IconButton(
            icon:
                Icon(isResepDisimpan ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () async {
              if (isResepDisimpan) {
                await hapusResep();
                // Tambahkan logika lain yang diperlukan, seperti notifikasi bahwa resep telah dihapus
              } else {
                await simpanResep();
                // Tambahkan logika lain yang diperlukan, seperti notifikasi bahwa resep telah disimpan
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan gambar resep dengan border radius circular
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(widget.sayur.gambar.toString()),
                  fit: BoxFit.cover,
                ),
              ),
              height: 200,
              width: double.infinity,
            ),
            SizedBox(height: 16.0),
            // Menampilkan ikon dan informasi tambahan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Waktu Masak
                buildInfoItem(Icons.access_time, widget.sayur.waktuMasak!),
                // Porsi
                buildInfoItem(Icons.restaurant, widget.sayur.porsi!),
                // Tingkat Kesulitan
                buildInfoItem(Icons.star, widget.sayur.tingkatKesulitan!),
              ],
            ),
            SizedBox(height: 16.0),
            // Menampilkan bahan-bahan
            buildSectionTitle('Bahan-bahan'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.sayur.bahan!
                  .map((bahan) => buildIngredientCard(bahan))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            // Menampilkan langkah-langkah
            buildSectionTitle('Langkah-langkah'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.sayur.langkah!
                  .asMap()
                  .map((index, langkah) =>
                      MapEntry(index, buildStepCard(index + 1, langkah)))
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        // Membuat ikon sedikit dikecilkan
        Icon(icon, size: 30),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  Widget buildIngredientCard(String ingredient) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '- $ingredient',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget buildStepCard(int stepNumber, String stepText) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          'Langkah $stepNumber',
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text(
          stepText,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
