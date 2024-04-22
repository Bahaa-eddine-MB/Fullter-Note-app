import 'package:intl/intl.dart';

class Note {
  String title;
  String description;
  DateTime date;

  Note({required this.title, required this.description, required this.date});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': DateFormat('yyyy-MM-dd - kk:mm').format(date),
    };
  }

  // Convert a Map into a Note. The keys must correspond to the names of the
  // columns in the database.
  Note.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        date = DateTime.parse(map['date']);
}
