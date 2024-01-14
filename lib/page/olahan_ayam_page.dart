import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:resep_makanan/model/model_olahan_ayam.dart';
import 'package:resep_makanan/page/detail_screen_ayam.dart';
import 'package:resep_makanan/page/about_page.dart';

class OlahanAyam extends StatefulWidget {
  const OlahanAyam({Key? key}) : super(key: key);

  @override
  _OlahanAyamState createState() => _OlahanAyamState();
}

class _OlahanAyamState extends State<OlahanAyam> {
  late Future<List<ModelAyam>> _ayamList;
  Future<List<ModelAyam>>? _filteredAyamList; // Nullable Future
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ayamList = readJsonData();
    _filteredAyamList = _ayamList; // Initialize _filteredAyamList with _ayamList
  }

  Future<List<ModelAyam>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/olahanayam.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ModelAyam.fromJson(e)).toList();
  }

  void _filterAyamList(String query) {
    _ayamList.then((list) {
      setState(() {
        _filteredAyamList = Future.value(
          list
              .where((ayam) =>
                  ayam.nama!.toLowerCase().contains(query.toLowerCase()))
              .toList(),
              
        );
      });
    });
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
              "Olahan Ayam",
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 15,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterAyamList,
              decoration: InputDecoration(
                labelText: 'Cari Resep Ayam',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModelAyam>>(
              future: _filteredAyamList ?? _ayamList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<ModelAyam> ayamList = snapshot.data ?? [];
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: ayamList.length,
                    itemBuilder: (context, index) {
                      ModelAyam ayam = ayamList[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreenAyam(ayam: ayam),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.network(
                                  ayam.gambar.toString(),
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      ayam.nama!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

