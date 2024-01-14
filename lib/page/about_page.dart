import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(
              fontSize: 17.5,
              fontFamily: "Poppins-SemiBold",
              color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black, size: 15),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/icon.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Farhan Rahman Permana',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Ryvannio Satria Nugroho',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'TI-2A  4.33.22.0.07',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Text(
              'TI-2A  4.33.22.0.25',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('farhanrhmnprmn@gmail.com'),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('ryvanniosatria@gmail.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
