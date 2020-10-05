import 'package:flutter/material.dart';
import 'package:otter_notes/screens/home/note.dart';

class EditNote extends StatefulWidget {
  EditNote(this.note, {Key key}) : super(key: key);
  final Note note;

  @override
  _EditNoteState createState() => _EditNoteState(note);
}

class _EditNoteState extends State<EditNote> {
  final Note note;

  _EditNoteState(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.name)),
      body: Center(
          child: Column(
        children: [
          Text('Modified: ${note.date}'),
        ],
      )),
    );
  }
}
