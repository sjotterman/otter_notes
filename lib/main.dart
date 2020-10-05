import 'package:flutter/material.dart';
import 'package:otter_notes/screens/edit_note/edit_note.dart';
import 'package:otter_notes/screens/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Otter Notes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: Home());
  }
}
