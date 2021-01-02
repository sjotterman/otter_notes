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
      NoteService().setNoteDir(result).then((_) {
        NoteService().noteDir.then((dir) {
          print('updated dir: $dir');
          setState(() {
            _noteDir = dir;
          });
        });
      });
    }
  }

  Future<void> _onPressResetDir() async {
    // TODO: confirmation prompt
    await NoteService().resetNoteDir().then((_) {
      NoteService().noteDir.then((dir) {
        print('updated dir: $dir');
        setState(() {
          _noteDir = dir;
        });
      });
    });
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
                onPressed: _onPressResetDir,
                label: Text('Reset'),
                icon: Icon(Icons.remove),
              ),
            ],
          ),
        ));
  }
}
