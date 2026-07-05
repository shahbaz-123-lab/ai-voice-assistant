/// Ye enum batata hai ke message kisne bheja - user ne ya AI assistant ne.
/// Enum use karne ka fayda: sirf ye do fixed options hi allowed hain,
/// koi galat spelling wali string ("Usre", "asistant") ka risk nahi rehta.
enum MessageSender { user, assistant }

/// ChatMessage ek "model class" hai.
/// Model class ka kaam hota hai: real duniya ki cheez (yahan: ek chat message)
/// ko Dart object ki shakal mein represent karna.
class ChatMessage {
  final String text; // Message ka actual content
  final MessageSender sender; // Kisne bheja - user ya assistant
  final DateTime timestamp; // Message kis waqt bana

  ChatMessage({
    required this.text,
    required this.sender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  // Agar timestamp nahi diya gaya to automatically current time set ho jayega.
}
