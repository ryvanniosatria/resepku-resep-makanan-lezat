import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:resep_makanan/model/model_olahan_daging.dart';
import 'package:resep_makanan/page/detail_screen_daging.dart';
import 'package:resep_makanan/page/about_page.dart';

class OlahanDaging extends StatefulWidget {
  const OlahanDaging({Key? key}) : super(key: key);

  @override
  _OlahanDagingState createState() => _OlahanDagingState();
}

class _OlahanDagingState extends State<OlahanDaging> {
  late Future<List<ModelDaging>> _dagingList;
  Future<List<ModelDaging>>? _filteredDagingList; // Nullable Future
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dagingList = readJsonData();
    _filteredDagingList = _dagingList; // Initialize _filteredDagingList with _dagingList
  }

  Future<List<ModelDaging>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/olahandaging.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ModelDaging.fromJson(e)).toList();
  }

  void _filterDagingList(String query) {
    _dagingList.then((list) {
      setState(() {
        _filteredDagingList = Future.value(
          list
              .where((daging) =>
                  daging.nama!.toLowerCase().contains(query.toLowerCase()))
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
              "Olahan Daging",
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
              onChanged: _filterDagingList,
              decoration: InputDecoration(
                labelText: 'Cari Resep Daging',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModelDaging>>(
              future: _filteredDagingList ?? _dagingList,
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
                  List<ModelDaging> dagingList = snapshot.data ?? [];
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: dagingList.length,
                    itemBuilder: (context, index) {
                      ModelDaging daging = dagingList[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreenDaging(daging: daging),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.network(
                                  daging.gambar.toString(),
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
                                      daging.nama!,
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