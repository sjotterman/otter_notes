import 'package:flutter/material.dart';
import 'package:otter_notes/screens/home/note.dart';
import 'package:otter_notes/services/note_service.dart';

class EditNote extends StatefulWidget {
  EditNote(this.note, {Key key}) : super(key: key);
  final Note note;

  @override
  _EditNoteState createState() => _EditNoteState(note);
}

class _EditNoteState extends State<EditNote> {
  final Note note;
  String _noteContents = 'loading...';
  void initState() {
    super.initState();
    NoteService().readNote(note.name).then((contents) {
      setState(() {
        _noteContents = contents;
      });
    });
  }

  _EditNoteState(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.name)),
      body: Center(
          child: Column(
        children: [
          Text(_noteContents),
        ],
      )),
    );
  }
}
