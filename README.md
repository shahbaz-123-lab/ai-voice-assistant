# AI Voice Assistant (Flutter + Groq API)

Ek professional AI-powered voice assistant jo aapki awaaz sunta hai,
AI se jawab leta hai, aur wapas bol kar sunata hai.

## Setup Steps (in order follow karein)

### 1. Groq API Key hasil karein (FREE hai)
1. https://console.groq.com/keys par jayein
2. Sign up / login karein
3. "Create API Key" par click karein
4. Key copy kar lein

### 2. API Key project mein daalein
`lib/services/ai_service.dart` file kholein aur ye line dhoondein:

```dart
static const String _apiKey = 'YOUR_GROQ_API_KEY_HERE';
```

Yahan apni asal key paste kar dein.

### 3. Dependencies install karein
Terminal mein project folder ke andar jakar:

```bash
flutter pub get
```

### 4. Android Permissions
`android/app/src/main/AndroidManifest.xml` already updated hai is project mein
(RECORD_AUDIO aur INTERNET permissions add ki gayi hain).

### 5. iOS Permissions
`ios/Runner/Info-permissions-snippet.plist` mein diya gaya code
apni `ios/Runner/Info.plist` file mein `<dict>` tag ke andar paste karein.

### 6. App run karein
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                          # App ka entry point
├── models/
│   └── chat_message.dart              # Chat message data model
├── services/
│   ├── speech_service.dart            # Voice → Text
│   ├── tts_service.dart               # Text → Voice
│   └── ai_service.dart                # Groq API se communication
├── providers/
│   └── voice_assistant_provider.dart  # Sara state management + logic
├── screens/
│   └── voice_assistant_screen.dart    # Main UI screen
└── widgets/
    ├── chat_bubble.dart                # Chat message bubble
    └── mic_button.dart                 # Animated mic button
```

## Kaise kaam karta hai (Flow)

```
User Mic Button Dabata Hai
        ↓
SpeechService sunna shuru karta hai
        ↓
Awaaz → Text mein convert hoti hai (live)
        ↓
User bolna band karta hai
        ↓
Text AiService ke through Groq API ko jata hai
        ↓
AI jawab generate karta hai
        ↓
Jawab chat list mein add hota hai
        ↓
TtsService jawab ko awaaz mein bolta hai
        ↓
Wapas Idle state - button dobara dabane ke liye ready
```

## Future Improvements (aap khud try karein)

- Multiple languages support add karein (Urdu voice bhi)
- Conversation history ko local database (sqflite) mein save karein
- Wake word detection add karein ("Hey Assistant" bol kar activate karna)
- Dark/Light theme toggle
