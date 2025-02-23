import 'package:diaguard1/core/screens/usertype.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diaguard App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AppUser(),
    );
  }
}
