import 'package:controller_app/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:controller_app/screens/Scanner.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

