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
  Note(name: 'another note', date: '2020-07-03'),
];

class _HomeState extends State<Home> {
  List<Note> filteredNotes = fakeNotes;
  String searchFieldText;

  void onSearchChanged(text) {
    print("Search field value: $text");
    setState(() {
      searchFieldText = text;
      filteredNotes = fakeNotes.where((note) {
        return note.name.toLowerCase().contains(text.toString().toLowerCase());
      }).toList();
    });
  }

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
              decoration: InputDecoration(hintText: 'Create or find a note'),
              onChanged: onSearchChanged,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    return NoteListItem(note: filteredNotes[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
