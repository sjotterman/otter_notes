import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:otter_notes/screens/home/note.dart';
import 'package:otter_notes/services/note_service.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class EditNote extends StatefulWidget {
  EditNote(this.note, {Key key}) : super(key: key);
  final Note note;

  @override
  _EditNoteState createState() => _EditNoteState(note);
}

class _EditNoteState extends State<EditNote> {
  final Note note;
  final _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController _controller = new TextEditingController();

  void initState() {
    super.initState();
    NoteService().readNote(note.fileName).then((contents) {
      setState(() {
        _controller.text = contents;
      });
    });
  }

  _EditNoteState(this.note);

  void _onContentsChanged(text) {
    _debouncer.run(() {
      NoteService().writeNote(note.fileName, text);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.name)),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
                  onChanged: _onContentsChanged,
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
