import 'package:flutter/material.dart';
import 'package:otter_notes/screens/home/note.dart';
import 'package:otter_notes/screens/home/note_list_item.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

List<Note> fakeNotes = [
  Note(name: 'Meeting notes', date: '2020-10-01'),
  Note(name: 'grocery list', date: '2020-09-15'),
  Note(name: 'todo list', date: '2020-09-01'),
  Note(name: 'app ideas', date: '2020-08-01'),
  Note(name: 'favorite foods', date: '2020-07-03'),
  Note(name: 'packing list', date: '2020-07-03'),
  Note(name: 'motorcycles', date: '2020-07-03'),
  Note(name: 'not a real note', date: '2020-07-03'),
  Note(name: 'this is just for extra items', date: '2020-07-03'),
  Note(name: 'doesn\'t matter what this is called', date: '2020-07-03'),
  Note(name: 'another note', date: '2020-07-03'),
  Note(name: 'more app ideas', date: '2020-07-03'),
];

class _HomeState extends State<Home> {
  List<Note> _filteredNotes = fakeNotes;
  String _searchFieldText = '';
  bool _showCreateButton = false;

  void _onSearchChanged(text) {
    setState(() {
      _searchFieldText = text;
      _filteredNotes = fakeNotes.where((note) {
        return note.name.toLowerCase().contains(text.toString().toLowerCase());
      }).toList();
      bool isOriginalName = fakeNotes.every((element) {
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
    }
    if (_filteredNotes.length == 0) {
      print('No matches');
      print('create $_searchFieldText');
    }
  }

  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Create or find a note',
                suffixIcon: _searchFieldText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          this.setState(() {
                            _searchFieldText = '';
                          });
                          _onSearchChanged('');
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
                      print("Create note called '$_searchFieldText'");
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
                    return NoteListItem(note: _filteredNotes[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
