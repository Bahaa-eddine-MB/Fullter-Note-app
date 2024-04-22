import 'package:flutter/material.dart';
import 'package:note_apps/Models/note_model.dart';
import 'package:note_apps/utils/routeObserver.dart';
import 'package:note_apps/utils/text_to_speech.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key, required this.note});
  final NoteModel note;

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen>
    with RouteAware, WidgetsBindingObserver {
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
    await TextToSpeech.stopSpeaking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/notes.png",
                height: 200,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                widget.note.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                widget.note.description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              Text(widget.note.date.toString()),
              IconButton(
                icon: Icon(isSpeaking ? Icons.stop : Icons.volume_up),
                onPressed: () async {
                  if (isSpeaking) {
                    await TextToSpeech.stopSpeaking();
                    setState(() {
                      isSpeaking = false;
                    });
                  } else {
                    setState(() {
                      isSpeaking = true;
                    });
                    String speakText =
                        "Note title: ${widget.note.title}. Note description: ${widget.note.description}";
                    await TextToSpeech.speak(speakText);
                  }
                },
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
