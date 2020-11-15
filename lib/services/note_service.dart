import 'dart:io';
import 'package:otter_notes/screens/home/note.dart';
import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';

class NoteService {
  // TODO: user selectable path
  Future<String> get noteDir async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> writeNote(String fileName, String content) async {
    final path = await noteDir;
    final file = File('$path/$fileName');
    print('Writing: $content');
    return file.writeAsString(content);
  }

  Future<Note> createNote(String fileName) async {
    File newNoteFile = await writeNote(fileName, '');
    Note newNote = Note(
      fileName: fileName,
      name: path.basenameWithoutExtension(newNoteFile.path),
      modified: DateTime.now(),
    );
    return newNote;
  }

  Future<String> readNote(String fileName) async {
    try {
      final path = await noteDir;
      final file = File('$path/$fileName');

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      print('error reading note');
      print(e.toString());
      return 'error';
    }
  }

  Future<List<Note>> listNotes() async {
    String localPath = await noteDir;
    Directory dir = Directory(localPath);
    List<FileSystemEntity> listOfAllFolderAndFiles =
        await dir.list(recursive: false).toList();
    List<FileSystemEntity> listOfNotes = listOfAllFolderAndFiles.where((item) {
      String extension = path.extension(item.path);
      return extension == '.md';
    }).toList();

    var notes = listOfNotes.map((item) async {
      // TODO: change statSync, as it could be slow
      if (!(item is File)) {
        return null;
      }
      File file = (item as File);
      String content = await file.readAsString();
      return Note(
          name: path.basenameWithoutExtension(item.path),
          fileName: path.basename(item.path),
          modified: item.statSync().modified,
          content: content);
    }).toList();
    return await Future.wait(notes);
  }
}
