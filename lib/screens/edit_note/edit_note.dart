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
  final List<String> history = [];
  final _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController _controller = new TextEditingController();

  void initState() {
    super.initState();
    NoteService().readNote(note.fileName).then((contents) {
      setState(() {
        _controller.text = contents;
        history.add(contents);
      });
    });
  }

  _EditNoteState(this.note);

  // TODO: find a better way to save changes rather than on every edit. Undo?
  void _onContentsChanged(text) {
    _debouncer.run(() {
      NoteService().writeNote(note.fileName, text);
      history.add(text);
      print("history: " + history.toString());
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  void _restoreNote() {
    print('press restore');
    if (history.length < 2) {
      // TODO: Alert here
      print('No further changes!');
      return;
    }
    var origText = history[0];
    setState(() {
      history.clear();
      history.add(origText);
      _controller.text = origText;
    });
  }

  _showResetConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Discard"),
      onPressed: () {
        _restoreNote();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure you want to discard all changes?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onPressUndo() {
    print('press undo');
    if (history.length < 2) {
      print('history is smaller than 2');
      return;
    }
    var newText;
    history.removeLast();
    setState(() {
      newText = history.last;
      _controller.text = newText;
    });
    print(newText);
    NoteService().writeNote(note.fileName, newText);
  }

  @override
  Widget build(BuildContext context) {
    // var hasChanges = history.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.name),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.undo),
              // onPressed: hasChanges ? _onPressUndo : null,
              onPressed: _onPressUndo),
          IconButton(
              icon: Icon(Icons.restore),
              onPressed: () {
                _showResetConfirmDialog(context);
              }),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
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
