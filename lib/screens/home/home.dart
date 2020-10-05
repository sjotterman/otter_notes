import 'package:flutter/material.dart';
import 'package:otter_notes/screens/edit_note/edit_note.dart';
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
