import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class Mms {
  final AudioPlayer _player = AudioPlayer();

  final String key;
  Mms({required this.key});

  static const Map<String, String> _isoMap = {
    "en-US": "eng",   // English
    "hi-IN": "hin",   // Hindi
    "ja-JP": "jpn",   // Japanese
    "as-IN": "asm",   // Assamese
    "bn-IN": "ben",   // Bengali
    "bh-IN": "hin",   // Bhojpuri
    "gu-IN": "guj",   // Gujarati
    "kn-IN": "kan",   // Kannada
    "ml-IN": "mal",   // Malayalam
    "mr-IN": "mar",   // Marathi
    "mai-IN": "mai",  // Maithili
    "or-IN": "ory",   // Odia
    "pa-IN": "pan",   // Punjabi
    "ta-IN": "tam",   // Tamil
    "te-IN": "tel",   // Telugu
    "ur-IN": "urd",   // Urdu
    "ne-NP": "nep",   // Nepali
    "fr-FR": "fra",   // French
    "de-DE": "deu",   // German
    "es-ES": "spa",   // Spanish
  };

  Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  String _model(String langCode) {
    return "facebook/mms-tts-${_isoMap[langCode]}";
  }

  Future<void> speak(String text, String langCode) async {
    final model = _model(langCode);

    try {
      final audio = await _fetchAudio(text, model);
      if (audio == null) {
        print("Failed to fetch audio, ${audio}");
        return;
      }
      final file = await _saveAudioFile(audio);
      await _player.play(DeviceFileSource(file.path));
    } catch (e) {
      print("Error in Mms TTS: $e");
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<List<int>?> _fetchAudio(String text, String model) async {
    final url = Uri.parse("https://api-inference.huggingface.co/models/$model");

    final response = await http.post(
      url,
      headers: {
        'Authorization': "Bearer $key",
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"inputs": text}),
    );
    if (response.statusCode == 200) {
      return base64Decode(response.body);
    } else {
      print("MMS API Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  Future<File> _saveAudioFile(List<int> audioData) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/mms_tts_audio.wav');
    await file.writeAsBytes(audioData);
    return file;
  }
}
