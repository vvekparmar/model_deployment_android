import 'package:flutter/material.dart';
import 'package:sound_classification_tflite/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Classification',
      theme: ThemeData.dark(),
      home: BuildModel(),
    );
  }
}
