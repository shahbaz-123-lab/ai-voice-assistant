import 'package:flutter/material.dart';
import '../models/chat_message.dart';

/// Ek chhota, reusable widget - sirf ek message ko "bubble" ki
/// shakal mein dikhata hai. Reusable widgets banana Flutter ki
/// sabse bari best practice hai - "Don't Repeat Yourself" (DRY).
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.sender == MessageSender.user;

    return Align(
      // User ke messages right side, AI ke messages left side
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          // Bubble screen ki 75% width se zyada wide nahi hogi
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF6C5CE7) : Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
