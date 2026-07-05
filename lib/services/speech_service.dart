import 'package:speech_to_text/speech_to_text.dart' as stt;

/// SERVICE LAYER kya hoti hai?
/// Professional apps mein hum UI code (widgets) aur "kaam karne wala" code
/// (jaise mic access karna, API call karna) ko alag rakhte hain.
/// Ye separation "Separation of Concerns" kehlata hai - ek best practice.
///
/// SpeechService ka sirf ek kaam hai: microphone se awaaz sun kar
/// usay text mein convert karna. UI ko is bat se koi matlab nahi
/// ke ye kaam "speech_to_text" package internally kaise karta hai.
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isAvailable = false;

  /// App start hote hi ek dafa call hota hai taake device ka speech
  /// recognition engine ready ho jaye (permission check bhi isi mein hoti hai).
  Future<bool> initialize() async {
    isAvailable = await _speech.initialize(
      onError: (error) => print('Speech error: $error'),
      onStatus: (status) => print('Speech status: $status'),
    );
    return isAvailable;
  }

  /// Listening start karta hai.
  /// onResult: har chand milliseconds baad jo bhi words pehchane jate hain,
  ///           wo yahan wapas bheje jate hain (isay "callback" kehte hain).
  /// onListeningComplete: jab user bolna band kar de to ye call hota hai.
  void startListening({
    required Function(String text) onResult,
    required Function() onListeningComplete,
  }) {
    _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
        if (result.finalResult) {
          onListeningComplete();
        }
      },
      listenFor: const Duration(seconds: 30), // max kitni dair sun sakta hai
      pauseFor: const Duration(seconds: 3), // kitni khamoshi ke baad rukna hai
      partialResults: true, // bolte bolte hi text dikhta rahe
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  void stopListening() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
