import 'dart:convert';
import 'package:http/http.dart' as http;

/// AiService ka kaam: user ke bole hue text ko AI model (LLM) ko
/// bhejna aur uska jawab wapas lana.
///
/// Hum Groq API use kar rahe hain kyunki ye FREE tier deta hai
/// aur bohot fast response deta hai (Groq apna khaas hardware -
/// LPU - use karta hai jo normal GPU se tez hai).
class AiService {
  // ⚠️ IMPORTANT: Apni Groq API key yahan dalein.
  // Free key yahan se milegi: https://console.groq.com/keys
  static const String _apiKey = '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';

  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  /// Conversation history yahan store hoti hai taake AI ko
  /// "context" yaad rahe - matlab pichli baaton ka pata ho.
  /// System message se hum AI ko batate hain ke usay kaisa behave karna hai.
  final List<Map<String, String>> _conversationHistory = [
    {
      'role': 'system',
      'content':
          'You are a helpful, friendly voice assistant. Keep answers short '
          'and conversational (2-3 sentences max) since they will be spoken aloud.'
    }
  ];

  /// User ka message bhejta hai aur AI ka jawab return karta hai.
  Future<String> getResponse(String userMessage) async {
    _conversationHistory.add({'role': 'user', 'content': userMessage});

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': _conversationHistory,
          'temperature': 0.7, // creativity level (0 = strict, 1 = creative)
          'max_tokens': 300, // response ki max length
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;

        // AI ka jawab bhi history mein save karte hain taake
        // agla sawal poochte waqt context maintain rahe.
        _conversationHistory.add({'role': 'assistant', 'content': reply});
        return reply;
      } else {
        return 'Sorry, kuch masla ho gaya (Error ${response.statusCode}). '
            'Dobara koshish karein.';
      }
    } catch (e) {
      return 'Internet connection check karein - AI se connect nahi ho saka.';
    }
  }

  /// Conversation history ko reset karta hai (system message chhor kar).
  void clearHistory() {
    _conversationHistory.removeRange(1, _conversationHistory.length);
  }
}
