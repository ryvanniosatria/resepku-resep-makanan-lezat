import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:resep_makanan/model/model_olahan_telur.dart';
import 'package:resep_makanan/page/detail_screen_telur.dart';
import 'package:resep_makanan/page/about_page.dart';

class OlahanTelur extends StatefulWidget {
  const OlahanTelur({Key? key}) : super(key: key);

  @override
  _OlahanTelurState createState() => _OlahanTelurState();
}

class _OlahanTelurState extends State<OlahanTelur> {
  late Future<List<ModelTelur>> _telurList;
  Future<List<ModelTelur>>? _filteredTelurList; // Nullable Future
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _telurList = readJsonData();
    _filteredTelurList = _telurList; // Initialize _filteredAyamList with _ayamList
  }

  Future<List<ModelTelur>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/olahantelur.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ModelTelur.fromJson(e)).toList();
  }

  void _filterTelurList(String query) {
    _telurList.then((list) {
      setState(() {
        _filteredTelurList = Future.value(
          list
              .where((telur) =>
                  telur.nama!.toLowerCase().contains(query.toLowerCase()))
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
              "Olahan Telur",
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
              onChanged: _filterTelurList,
              decoration: InputDecoration(
                labelText: 'Cari Resep Telur',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModelTelur>>(
              future: _filteredTelurList ?? _telurList,
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
                  List<ModelTelur> telurList = snapshot.data ?? [];
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: telurList.length,
                    itemBuilder: (context, index) {
                      ModelTelur telur = telurList[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreenTelur(telur: telur),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.network(
                                  telur.gambar.toString(),
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
                                      telur.nama!,
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

