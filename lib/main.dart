import 'package:flutter/material.dart';
import 'home_page.dart'; // Import halaman beranda
import 'login_page.dart'; // Import halaman login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CocktailDB ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Ganti halaman home dengan LoginPage
      home: LoginPage(), // Navigasi ke halaman login terlebih dahulu
    );
  }
}
