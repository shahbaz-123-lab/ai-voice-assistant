import 'package:flutter_tts/flutter_tts.dart';

/// TtsService ka kaam: AI ka text response lekar usay
/// device ke speaker se bolwana (Text-to-Speech = TTS).
class TtsService {
  final FlutterTts _tts = FlutterTts();

  TtsService() {
    _configure();
  }

  /// Voice settings configure karta hai.
  /// Ye har baar app start hone par ek dafa chalta hai.
  Future<void> _configure() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5); // bolne ki speed (0.0 se 1.0)
    await _tts.setPitch(1.0); // awaaz ka pitch (normal = 1.0)
    await _tts.setVolume(1.0); // volume level
  }

  /// Diya gaya text bolta hai.
  /// Pehle _tts.stop() isliye call kiya taake agar pehle se
  /// koi speech chal rahi ho to overlap na ho.
  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  /// Jab bolna khatam ho jaye to ye callback fire hota hai.
  /// Isay hum Provider mein use karenge taake assistant wapas
  /// "idle" state mein chala jaye.
  void onComplete(Function() callback) {
    _tts.setCompletionHandler(callback);
  }
}
