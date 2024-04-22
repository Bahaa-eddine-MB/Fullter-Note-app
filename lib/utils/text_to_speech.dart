import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static final FlutterTts flutterTts = FlutterTts();

  static Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  static Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  static Future<void> pauseSpeaking() async {
    await flutterTts.pause();
  }
}
