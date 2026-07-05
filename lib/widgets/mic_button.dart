import 'package:flutter/material.dart';
import '../providers/voice_assistant_provider.dart';

/// Mic button jo assistant ki current state ke hisab se
/// apna color aur icon change karta hai - ye "visual feedback"
/// ka professional example hai. User ko turant pata chalta hai
/// ke app kya kar raha hai (sun raha hai / soch raha hai / bol raha hai).
class MicButton extends StatelessWidget {
  final AssistantState state;
  final VoidCallback onPressed;

  const MicButton({super.key, required this.state, required this.onPressed});

  Color _getColor() {
    switch (state) {
      case AssistantState.listening:
        return Colors.redAccent;
      case AssistantState.thinking:
        return Colors.orangeAccent;
      case AssistantState.speaking:
        return Colors.greenAccent;
      case AssistantState.idle:
        return const Color(0xFF6C5CE7);
    }
  }

  IconData _getIcon() {
    switch (state) {
      case AssistantState.listening:
        return Icons.mic;
      case AssistantState.thinking:
        return Icons.hourglass_top;
      case AssistantState.speaking:
        return Icons.volume_up;
      case AssistantState.idle:
        return Icons.mic_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Button sirf idle ya listening state mein clickable hai
    final bool enabled =
        state == AssistantState.idle || state == AssistantState.listening;

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        // AnimatedContainer khud-ba-khud smooth transition karta hai
        // jab bhi width/height/color change ho.
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getColor(),
          boxShadow: [
            BoxShadow(
              color: _getColor().withOpacity(0.5),
              blurRadius: 20,
              // Listening ke waqt glow bara ho jata hai - "pulse" jaisa effect
              spreadRadius: state == AssistantState.listening ? 8 : 2,
            ),
          ],
        ),
        child: Icon(_getIcon(), color: Colors.white, size: 36),
      ),
    );
  }
}
