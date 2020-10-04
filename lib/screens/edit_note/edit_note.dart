import 'package:flutter/material.dart';
import 'package:otter_notes/screens/edit_note/edit_note_arguments.dart';

class EditNote extends StatefulWidget {
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  Widget build(BuildContext context) {
    final EditNoteArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
          child: Column(
        children: [
          Text('TODO'),
        ],
      )),
    );
  }
}
