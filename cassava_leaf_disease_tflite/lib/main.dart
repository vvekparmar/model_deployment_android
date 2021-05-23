import 'package:flutter/material.dart';
import 'package:cassava_leaf_disease_tflite/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cassava Leaf Disease',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BuildModel(),
    );
  }
}
