import 'package:flutter/material.dart';
import 'package:otter_notes/services/note_service.dart';

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

  void _onPressEditDir() {
    // TODO: open file picker
    // set new directory
    print('pressed edit dir');
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
              )
            ],
          ),
        ));
  }
}
