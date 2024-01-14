import 'package:flutter/material.dart';
import 'package:resep_makanan/page/home.dart';

void main() {
  runApp(SplashScreenApp());
}

class SplashScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resepku',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Show SplashScreen initially
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Choose your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo or image goes here
            Image.asset(
              "assets/images/icon.png", // Replace with your logo image path
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // A loading indicator
          ],
        ),
      ),
    );
  }
}
