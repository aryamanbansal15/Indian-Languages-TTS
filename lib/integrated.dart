library integrated_tts;

export 'src/manager.dart';
export 'src/flutter.dart';
export 'src/mms-tts.dart';

import 'src/manager.dart';

class MultiSpeaker{

  final String language;
  late final Manager _manager;


  MultiSpeaker({required this.language}) : _manager = Manager(lang: language);

  Future<void> init() async {
    await _manager.init();
  }

  Future<void> speak(String text, String langCode) async {
    await _manager.speak(text);
  }

  Future<void> stop() async {
    await _manager.stop();
  }
}