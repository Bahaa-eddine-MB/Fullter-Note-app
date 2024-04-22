import 'package:flutter/material.dart';
import 'package:note_apps/Models/note_model.dart';
import 'package:note_apps/view/NoteScreen.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(
      {super.key,
      required this.note,
      required this.selectNote,
      required this.removeNote});
  final NoteModel note;
  final Function(NoteModel) selectNote;
  final Function(NoteModel) removeNote;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        selectNote(note);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    children: const [
                      Icon(Icons.warning_rounded, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Delete Note'),
                    ],
                  ),
                  content:
                      const Text('Are you sure you want to delete this note?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        removeNote(note);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
          leading: Image.asset("assets/notes.png"),
          title: Text(note.title),
          subtitle: Text(
            '${note.description.split(" ").take(3).join(" ")}...',
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailsScreen(note: note),
              ),
            );
          },
        ),
      ),
    );
  }
}
