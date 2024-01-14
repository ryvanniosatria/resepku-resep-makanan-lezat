import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:resep_makanan/model/model_olahan_sayur.dart';
import 'package:resep_makanan/page/detail_screen_sayur.dart';
import 'package:resep_makanan/page/about_page.dart';

class OlahanSayur extends StatefulWidget {
  const OlahanSayur({Key? key}) : super(key: key);

  @override
  _OlahanSayurState createState() => _OlahanSayurState();
}

class _OlahanSayurState extends State<OlahanSayur> {
  late Future<List<ModelSayur>> _sayurList;
  Future<List<ModelSayur>>? _filteredSayurList; // Nullable Future
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sayurList = readJsonData();
    _filteredSayurList =
        _sayurList; // Initialize _filteredSayurList with _sayurList
  }

  Future<List<ModelSayur>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/olahansayur.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ModelSayur.fromJson(e)).toList();
  }

  void _filterSayurList(String query) {
    _sayurList.then((list) {
      setState(() {
        _filteredSayurList = Future.value(
          list
              .where((sayur) =>
                  sayur.nama!.toLowerCase().contains(query.toLowerCase()))
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
              "Olahan Sayur",
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
              onChanged: _filterSayurList,
              decoration: InputDecoration(
                labelText: 'Cari Resep Sayur',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModelSayur>>(
              future: _filteredSayurList ?? _sayurList,
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
                  List<ModelSayur> sayurList = snapshot.data ?? [];
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: sayurList.length,
                    itemBuilder: (context, index) {
                      ModelSayur sayur = sayurList[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreenSayur(sayur: sayur),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.network(
                                  sayur.gambar.toString(),
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
                                      sayur.nama!,
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
