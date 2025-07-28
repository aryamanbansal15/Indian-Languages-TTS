import 'package:flutter_tts/flutter_tts.dart';

class Flutter{
  final FlutterTts _tts = FlutterTts();
  List<String> _languages = [];

  Future<void> init() async {
    var languages = await _tts.getLanguages;
    _languages = languages.cast<String>();
  }

  bool isLanguageSupported(String langCode) {
    return _languages.contains(langCode);
  }

  Future<void> speak(String text, String langCode) async {
    await _tts.setLanguage(langCode);
    await _tts.setPitch(0.8);
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
    print(_languages);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}