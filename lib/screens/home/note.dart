import 'package:flutter/foundation.dart';

class Note {
  String name;
  String fileName;
  DateTime modified;
  String content;

  Note(
      {@required this.name,
      @required this.fileName,
      @required this.modified,
      this.content});
}
