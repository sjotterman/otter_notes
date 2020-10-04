import 'package:flutter/material.dart';
import 'package:otter_notes/screens/home/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;

  const NoteListItem({Key key, this.note}) : super(key: key);

  void _onTap() {
    print("Tapped '${note.name}'");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        child: Card(
          child: ListTile(
            title: Text(note.name),
            subtitle: Text("Created: ${note.date}"),
            dense: true,
          ),
        ),
      ),
    );
  }
}
