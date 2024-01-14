import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:resep_makanan/model/model_olahan_seafood.dart';
import 'package:resep_makanan/page/detail_screen_seafood.dart';
import 'package:resep_makanan/page/about_page.dart';

class OlahanSeafood extends StatefulWidget {
  const OlahanSeafood({Key? key}) : super(key: key);

  @override
  _OlahanSeafoodState createState() => _OlahanSeafoodState();
}

class _OlahanSeafoodState extends State<OlahanSeafood> {
  late Future<List<ModelSeafood>> _seafoodList;
  Future<List<ModelSeafood>>? _filteredSeafoodList; // Nullable Future
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _seafoodList = readJsonData();
    _filteredSeafoodList = _seafoodList; // Initialize _filteredAyamList with _ayamList
  }

  Future<List<ModelSeafood>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/olahanseafood.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ModelSeafood.fromJson(e)).toList();
  }

  void _filterSeafoodList(String query) {
    _seafoodList.then((list) {
      setState(() {
        _filteredSeafoodList = Future.value(
          list
              .where((seafood) =>
                  seafood.nama!.toLowerCase().contains(query.toLowerCase()))
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
              "Olahan Seafood",
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
              onChanged: _filterSeafoodList,
              decoration: InputDecoration(
                labelText: 'Cari Resep Seafood',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModelSeafood>>(
              future: _filteredSeafoodList ?? _seafoodList,
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
                  List<ModelSeafood> seafoodList = snapshot.data ?? [];
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: seafoodList.length,
                    itemBuilder: (context, index) {
                      ModelSeafood seafood = seafoodList[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreenSeafood(seafood: seafood),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.network(
                                  seafood.gambar.toString(),
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
                                      seafood.nama!,
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

