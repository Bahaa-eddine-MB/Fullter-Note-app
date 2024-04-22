import 'package:flutter/material.dart';
import 'package:note_apps/Models/note_model.dart';
import 'package:note_apps/components/NoteCard.dart';
import 'package:note_apps/utils/routeObserver.dart';
import 'package:note_apps/utils/text_to_speech.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with RouteAware, WidgetsBindingObserver {
  List<Note> notes = [];
  Note? selectedNote;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      print("did change lifecycle state");
      await TextToSpeech.stopSpeaking();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ObserverUtils.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPop() async {
    print("did pop first");
    await TextToSpeech.stopSpeaking();
  }

  @override
  void didPopNext() async {
    print("did pop");
    await TextToSpeech.stopSpeaking();
  }

  @override
  void didPushNext() async {
    print("did push");
    await TextToSpeech.stopSpeaking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Note Apps",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note_add_outlined),
        onPressed: () async {
          final result = await showDialog<Note>(
            context: context,
            builder: (context) {
              String title = '';
              String description = '';
              return AlertDialog(
                title: const Text('Add a new note'),
                content: SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom == 0.0
                      ? MediaQuery.of(context).size.height * .5
                      : null,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) => title = value,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            hintText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        TextField(
                          maxLines: 3,
                          onChanged: (value) => description = value,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      Navigator.of(context).pop(Note(
                          title: title,
                          description: description,
                          date: DateTime.now()));
                    },
                  ),
                ],
              );
            },
          );
          if (result != null) {
            setState(() {
              notes.add(result);
            });
          }
        },
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // Landscape mode
            return Row(
              children: [
                Expanded(
                  child: _buildNotesList(),
                ),
                Expanded(
                  child: selectedNote == null
                      ? Container()
                      : _buildNoteDetails(selectedNote!),
                ),
              ],
            );
          } else {
            return _buildNotesList();
          }
        },
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteCard(
            note: notes[index],
            selectNote: (note) {
              setState(() {
                selectedNote = notes[index];
              });
            },
            removeNote: (note) {
              setState(() {
                notes.remove(notes[index]);
              });
            });
      },
    );
  }

  Widget _buildNoteDetails(Note note) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/notes.png",
            height: 100,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            note.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            note.description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 35,
          ),
          Text(note.date.toString()),
          IconButton(
            icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
            onPressed: () async {
              if (isSpeaking) {
                TextToSpeech.stopSpeaking();
                setState(() {
                  isSpeaking = false;
                });
              } else {
                setState(() {
                  isSpeaking = true;
                });
                // Read the note title
                String speakText = "Note title: ${note.title}. Note description: ${note.description}";
                await TextToSpeech.speak(speakText);
              }
            },
          ),
        ],
      ),
    );
  }
}
