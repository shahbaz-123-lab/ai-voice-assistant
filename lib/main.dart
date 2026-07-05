import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/voice_assistant_provider.dart';
import 'screens/voice_assistant_screen.dart';

/// main() Dart mein wo pehla function hai jo app start hote hi chalta hai.
/// Har Dart program ko ek main() function chahiye - ye "entry point" hai.
void main() {
  runApp(const MyApp());
}

/// MyApp app ka sabse upar wala (root) widget hai.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider poori app ko VoiceAssistantProvider ka
    // access deta hai - kisi bhi child widget se is provider ko
    // context.watch() ya context.read() se access kiya ja sakta hai.
    return ChangeNotifierProvider(
      create: (_) => VoiceAssistantProvider(),
      child: MaterialApp(
        title: 'AI Voice Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF6C5CE7),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const VoiceAssistantScreen(),
      ),
    );
  }
}
