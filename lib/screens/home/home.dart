import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otter_notes/screens/edit_note/edit_note.dart';
import 'package:otter_notes/screens/edit_note/settings.dart';
import 'package:otter_notes/screens/home/note.dart';
import 'package:otter_notes/screens/home/note_list_item.dart';
import 'package:otter_notes/services/note_service.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  String _searchFieldText = '';
  bool _showCreateButton = false;
  final TextEditingController _controller = new TextEditingController();

  void initState() {
    super.initState();
    _getNoteList();
  }

  void _getNoteList() {
    NoteService().listNotes().then((notes) {
      setState(() {
        _allNotes = notes;
        _filteredNotes = notes;
      });
    });
  }

  void _onSearchChanged(text) {
    setState(() {
      _searchFieldText = text;
      _filteredNotes = _allNotes.where((note) {
        var titleMatch =
            note.name.toLowerCase().contains(text.toString().toLowerCase());
        var contentMatch =
            note.content.toLowerCase()?.contains(text.toString().toLowerCase());
        return (titleMatch || contentMatch);
      }).toList();
      bool isOriginalName = _allNotes.every((element) {
        return element.name != _searchFieldText;
      });
      _showCreateButton = isOriginalName && _searchFieldText.isNotEmpty;
    });
  }

  void _onEditingComplete() {
    print("Editing complete: ");
    print(_searchFieldText);
    if (_searchFieldText.isEmpty) {
      print('Empty, do nothing');
      return;
    }
    if (_filteredNotes.length == 1) {
      print('Only one item');
      print('open ${_filteredNotes[0].name}');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditNote(_filteredNotes[0]),
          ));
    }
    if (_filteredNotes.length == 0) {
      navigateToNewNote();
    }
  }

  void navigateToNewNote() {
    NoteService().createNote('$_searchFieldText.md').then((newNote) {
      _getNoteList();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditNote(newNote),
          ));
    });
    _clearSearch();
  }

  void _onFinishEdit() {
    _getNoteList();
    _clearSearch();
  }

  void _onPressSettings() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Settings(),
        ));
  }

  void _onPressDailyNote() {
    final now = new DateTime.now();

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dailyNoteTitle = formatter.format(now) + '.md';
    var existingNotes = _allNotes.where((note) {
      return note.fileName == dailyNoteTitle;
    }).toList();
    if (existingNotes == null) {
      NoteService().createNote(dailyNoteTitle).then((newNote) {
        _getNoteList();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNote(newNote),
            ));
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditNote(existingNotes[0]),
          ));
    }
    _clearSearch();
  }

  void _onPressRefresh() {
    print('refreshing');
    _getNoteList();
    _clearSearch();
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
      appBar: AppBar(
        title: Text('Search / Create Notes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _onPressDailyNote,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _onPressSettings,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onPressRefresh,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredNotes.length,
                  itemBuilder: (context, index) {
                    return NoteListItem(
                      note: _filteredNotes[index],
                      onFinishEdit: _onFinishEdit,
                    );
                  }),
            ),
            if (_showCreateButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Create '$_searchFieldText'"),
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateToNewNote();
                    },
                    label: Text('Create'),
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            TextField(
              autofocus: true,
              autocorrect: false,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Create or find a note',
                suffixIcon: _searchFieldText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _clearSearch();
                        })
                    : null,
              ),
              onChanged: _onSearchChanged,
              onEditingComplete: _onEditingComplete,
            ),
          ],
        ),
      ),
    );
  }

  void _clearSearch() {
    _controller.clear();
    this.setState(() {
      _searchFieldText = '';
    });
    _onSearchChanged('');
  }
}
