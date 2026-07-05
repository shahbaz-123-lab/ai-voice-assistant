import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/ai_service.dart';

/// Assistant kis "state" mein hai - ye 4 possibilities hain.
/// Enum use karne se UI ko exactly pata hota hai ke kya dikhana hai.
enum AssistantState { idle, listening, thinking, speaking }

/// PROVIDER PATTERN kya hai?
/// Ye "state management" ka ek professional tareeqa hai.
/// ChangeNotifier ek Flutter class hai jo "notifyListeners()" call karne par
/// tamam sunne walay (listening) widgets ko automatically rebuild kar deti hai.
///
/// Fayda: UI code (screens/widgets) mein koi business logic nahi likhna parta.
/// Sara logic yahan is provider mein rehta hai - clean architecture ka core idea.
class VoiceAssistantProvider extends ChangeNotifier {
  final SpeechService _speechService = SpeechService();
  final TtsService _ttsService = TtsService();
  final AiService _aiService = AiService();

  final List<ChatMessage> messages = [];
  AssistantState state = AssistantState.idle;
  String currentTranscript = '';

  VoiceAssistantProvider() {
    _init();
  }

  Future<void> _init() async {
    await _speechService.initialize();

    // Jab AI bolna khatam kare to state wapas idle kar do
    _ttsService.onComplete(() {
      state = AssistantState.idle;
      notifyListeners();
    });
  }

  /// Mic button dabane par ye call hota hai.
  Future<void> startListening() async {
    if (state != AssistantState.idle) return; // agar already busy hai to kuch na karo

    state = AssistantState.listening;
    currentTranscript = '';
    notifyListeners(); // UI ko batao ke state change ho gayi

    _speechService.startListening(
      onResult: (text) {
        currentTranscript = text;
        notifyListeners(); // live transcript UI par dikhta rahega
      },
      onListeningComplete: () async {
        await _handleUserSpeech(currentTranscript);
      },
    );
  }

  void stopListening() {
    _speechService.stopListening();
  }

  /// User ki speech complete hone ke baad ka pura flow yahan hota hai:
  /// 1. Message list mein add karo
  /// 2. AI ko bhejo
  /// 3. AI ka jawab list mein add karo
  /// 4. Jawab ko bulwao (speak)
  Future<void> _handleUserSpeech(String text) async {
    if (text.trim().isEmpty) {
      state = AssistantState.idle;
      notifyListeners();
      return;
    }

    messages.add(ChatMessage(text: text, sender: MessageSender.user));
    state = AssistantState.thinking;
    notifyListeners();

    final reply = await _aiService.getResponse(text);

    messages.add(ChatMessage(text: reply, sender: MessageSender.assistant));
    state = AssistantState.speaking;
    notifyListeners();

    await _ttsService.speak(reply);
  }

  /// Refresh button dabane par pura conversation reset ho jata hai.
  void reset() {
    messages.clear();
    _aiService.clearHistory();
    notifyListeners();
  }
}
