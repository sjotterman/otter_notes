import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otter Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'Open Note'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Note {
  String name;
  String date;

  Note({this.name, this.date});
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

class _MyHomePageState extends State<MyHomePage> {
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
              onChanged: (text) {
                print("Search field value: $text");
              },
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fakeNotes.length,
                  itemBuilder: (context, index) {
                    return NoteListItem(note: fakeNotes[index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteListItem extends StatelessWidget {
  final Note note;

  const NoteListItem({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text(note.name),
          subtitle: Text(note.date),
          dense: true,
        ),
      ),
    );
  }
}
