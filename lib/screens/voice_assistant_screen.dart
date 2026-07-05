import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_assistant_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/mic_button.dart';

/// Ye "Screen" hai - matlab app ka ek pura page.
/// Isay hum "View" bhi keh sakte hain - iska kaam sirf UI dikhana hai,
/// koi bhi business logic (jaise API call) yahan nahi likhi jati.
class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch() -> is widget ko Provider ke changes par
    // automatically rebuild karwata hai.
    final provider = context.watch<VoiceAssistantProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // context.read() -> sirf ek dafa action perform karne ke liye,
            // rebuild trigger nahi karta (onPressed jaisi jagah par ye sahi hai)
            onPressed: () => context.read<VoiceAssistantProvider>().reset(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== Chat messages list =====
          Expanded(
            child: provider.messages.isEmpty
                ? const Center(
                    child: Text(
                      'Mic button dabao aur bolna shuru karo 🎙️',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: provider.messages[index]);
                    },
                  ),
          ),

          // ===== Live transcript jab user bol raha ho =====
          if (provider.state == AssistantState.listening)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                provider.currentTranscript.isEmpty
                    ? 'Sun raha hoon...'
                    : provider.currentTranscript,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),

          // ===== "Thinking" indicator jab AI response soch raha ho =====
          if (provider.state == AssistantState.thinking)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Soch raha hoon...'),
            ),

          // ===== Mic Button =====
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: MicButton(
              state: provider.state,
              onPressed: () {
                if (provider.state == AssistantState.idle) {
                  provider.startListening();
                } else if (provider.state == AssistantState.listening) {
                  provider.stopListening();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
