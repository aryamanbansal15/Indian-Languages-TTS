import 'flutter.dart';
import 'mms-tts.dart';

class Manager
{
  final Flutter _flutter = Flutter();
  final Mms _mms = Mms(key: "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");

  final String lang;
  Manager({required this.lang});

  static const Map<String, String> _langMap = {
    "English": "en-US",
    "Hindi": "hi-IN",
    "Japanese": "ja-JP",
    "Assamese": "as-IN",
    "Bengali": "bn-IN",
    "Bhojpuri": "hi-IN",
    "Gujarati": "gu-IN",
    "Kannada": "kn-IN",
    "Malayalam": "ml-IN",
    "Marathi": "mr-IN",
    "Maithili": "mai-IN",
    "Odia": "or-IN",
    "Punjabi": "pa-IN",
    "Tamil": "ta-IN",
    "Telugu": "te-IN",
    "Urdu": "ur-IN",
    "Nepali": "ne-NP",
    "French": "fr-FR",
    "German": "de-DE",
    "Spanish": "es-ES",

  };

  Future<void> init() async {
    await _flutter.init();
    await _mms.init();
  }

  Future<void> speak(String text) async{
    final langCode = _langMap[lang] ?? 'en-US';
    if (_flutter.isLanguageSupported(langCode)) {
      try{
        await _flutter.speak(text, langCode);
      }catch(e)
      {
        _mms.speak(text, langCode);
      }
    }else {
      _mms.speak(text, langCode);
    }
  }

  Future<void> stop() async {
    await _mms.stop();
    await _flutter.stop();
  }
}
