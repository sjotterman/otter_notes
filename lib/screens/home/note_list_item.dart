import 'package:flutter/material.dart';
import 'package:otter_notes/screens/home/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;

  const NoteListItem({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text(note.name),
          subtitle: Text(note.date),
          dense: true,
        ),
      ),
    );
  }
}
