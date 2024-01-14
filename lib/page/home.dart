import 'package:flutter/material.dart';
import 'package:resep_makanan/page/chatPage.dart';
import 'package:resep_makanan/page/olahan_ayam_page.dart';
import 'package:resep_makanan/page/olahan_daging_page.dart';
import 'package:resep_makanan/page/olahan_ikan_page.dart';
import 'package:resep_makanan/page/olahan_sayur_page.dart';
import 'package:resep_makanan/page/olahan_telur_page.dart';
import 'package:resep_makanan/page/olahan_seafood_page.dart';
import 'package:resep_makanan/page/about_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resep_makanan/model/model_olahan_ayam.dart';
import 'package:resep_makanan/model/model_olahan_daging.dart';
import 'package:resep_makanan/model/model_olahan_ikan.dart';
import 'package:resep_makanan/model/model_olahan_sayur.dart';
import 'package:resep_makanan/model/model_olahan_telur.dart';
import 'package:resep_makanan/model/model_olahan_seafood.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi untuk mendapatkan daftar resep yang disimpan
  Future<List<dynamic>> ambilResepDisimpan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    List<dynamic> daftarResep = daftarResepString.map((json) {
      Map<String, dynamic> decoded = jsonDecode(json);
      if (decoded.containsKey('jenis') && decoded['jenis'] == 'ikan') {
        return ModelIkan.fromJson(decoded);
      } else if (decoded.containsKey('jenis') && decoded['jenis'] == 'ayam') {
        return ModelAyam.fromJson(decoded);
      } else if (decoded.containsKey('jenis') && decoded['jenis'] == 'sayur') {
        return ModelSayur.fromJson(decoded);
      } else if (decoded.containsKey('jenis') && decoded['jenis'] == 'telur') {
        return ModelTelur.fromJson(decoded);
      } else if (decoded.containsKey('jenis') &&
          decoded['jenis'] == 'seafood') {
        return ModelSeafood.fromJson(decoded);
      } else {
        return ModelDaging.fromJson(decoded);
      }
    }).toList();

    return daftarResep;
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

  // Fungsi untuk menghapus resep yang disimpan
  Future<void> hapusResep(dynamic resep) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Konversi resep yang akan dihapus menjadi JSON
    String resepJson = jsonEncode(resep.toJson());

    // Cari dan hapus resep dari daftar
    daftarResepString.remove(resepJson);
    await prefs.setStringList('daftarResep', daftarResepString);

    // Show the snack bar here
    await showCustomSnackBar('Resep ${resep.nama} telah dihapus dari daftar simpan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/home.jpeg"),
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
              "Resepku",
              style: TextStyle(
                fontSize: 17.5,
                fontFamily: 'Poppins-SemiBold',
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Tambahkan ikon untuk melihat resep yang disimpan di AppBar
          IconButton(
            icon: Icon(Icons.bookmark),
            color: Colors.black,
            onPressed: () async {
              List<dynamic> daftarResepDisimpan = await ambilResepDisimpan();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Resep yang Disimpan'),
                    content: Container(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height *
                          0.6, // Adjust height as needed
                      child: ListView.builder(
                        itemCount: daftarResepDisimpan.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                          daftarResepDisimpan[index].nama ??
                                              ''),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      hapusResep(daftarResepDisimpan[index]);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),

          IconButton(
            icon: Icon(Icons.info),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          padding: EdgeInsets.all(20.0),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanAyam()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_ayam.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Ayam",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanDaging()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_daging.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Daging",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanIkan()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_ikan.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Ikan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanSayur()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_sayur.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Sayur",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanTelur()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_telur.png"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Telur",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanSeafood()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_seafood.png"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Seafood",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
        child: Icon(Icons.chat), 
        backgroundColor: Color.fromARGB(
            255, 227, 234, 26), 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
