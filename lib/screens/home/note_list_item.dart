import 'package:flutter/material.dart';
import 'package:otter_notes/screens/edit_note/edit_note.dart';
import 'package:otter_notes/screens/home/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final Function onFinishEdit;

  const NoteListItem({Key key, this.note, this.onFinishEdit}) : super(key: key);

  // TODO: refactor so I don't need to manually call onFinishEdit()
  void _onTap(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNote(note),
        )).then((value) => onFinishEdit());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        child: Card(
          child: ListTile(
            title: Text(note.name),
            subtitle: Text("Modified: ${note.modified.toLocal().toString()}"),
            dense: true,
          ),
        ),
      ),
    );
  }
}
