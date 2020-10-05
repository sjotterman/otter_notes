import 'package:flutter/material.dart';
import 'package:otter_notes/screens/edit_note/edit_note.dart';
import 'package:otter_notes/screens/home/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;

  const NoteListItem({Key key, this.note}) : super(key: key);

  void _onTap(context) {
    print("Tapped '${note.name}'");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNote(note),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        child: Card(
          child: ListTile(
            title: Text(note.name),
            subtitle: Text("Modified: ${note.date}"),
            dense: true,
          ),
        ),
      ),
    );
  }
}
