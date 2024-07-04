import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive/models/person.dart';
import 'package:hive_flutter/screens/person_input.dart';

Future<void> main() async {
  var path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(PersonAdapter());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PersonInputScreen(),
      ),
    );
  }
}
