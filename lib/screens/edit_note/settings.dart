import 'package:flutter/material.dart';
import 'package:otter_notes/services/note_service.dart';
import 'package:file_picker/file_picker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _noteDir = '...';

  void initState() {
    super.initState();
    NoteService().noteDir.then((dir) {
      print('updated dir: $dir');
      setState(() {
        _noteDir = dir;
      });
    });
  }

  Future<void> _onPressEditDir() async {
    String result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      await NoteService().setNoteDir(result);
      var dir = await NoteService().noteDir;
      setState(() {
        _noteDir = dir;
      });
    }
  }

  Future<void> _resetDir() async {
    await NoteService().resetNoteDir();
    var dir = await NoteService().noteDir;
    setState(() {
      _noteDir = dir;
    });
  }

  showResetConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        _resetDir();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure you want to reset the note directory?"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Notes Directory'),
              Text(_noteDir),
              ElevatedButton.icon(
                onPressed: _onPressEditDir,
                label: Text('Edit'),
                icon: Icon(Icons.edit),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showResetConfirmDialog(context);
                },
                label: Text('Reset'),
                icon: Icon(Icons.remove),
              ),
            ],
          ),
        ));
  }
}
