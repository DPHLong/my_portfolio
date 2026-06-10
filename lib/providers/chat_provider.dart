import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/env.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((
  ref,
) {
  return ChatNotifier();
});

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]) {
    // Add a welcome message
    state = [
      ChatMessage(
        text:
            "Hi there! I'm the AI Assistant for Pham Hoang Long Dang. I know all about his skills, experience, and projects. What would you like to know?",
        isUser: false,
      ),
    ];
    _initModel();
  }

  late final GenerativeModel _model;
  late final ChatSession _chat;

  void _initModel() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: Env.geminiApiKey,
      systemInstruction: Content.system('''
You are the personal AI Assistant for Pham Hoang Long Dang's portfolio website. 
Your goal is to represent him professionally and answer questions from potential employers or clients about his background.

Here is the key information about Pham Hoang Long Dang:
- **Role**: Software Developer focusing on Flutter & Firebase, with a background in Java, C#, and currently training in AI Engineering.
- **Experience**:
  - 2026-Now: Training in AI-Engineering (Private Learning) - LLMs, prompt engineering, AI Agents.
  - 2025-2026: Training in Java, C#, MySQL (IHK Berlin) - Clean architecture, system design.
  - 2022-2025: Flutter Developer at Timee GmbH - Cross-platform mobile apps, calendar/events, chat/video, Firebase.
  - 2018-2019: Junior Android Developer Intern at Benefit GmbH.
  - 2018-2022: Student in Software Engineering at FU Berlin.
- **Projects**:
  - E-Commerce App (Spring Boot, REST, JPA, JWT, AWS)
  - AI Agent (Flutter, Gemini API)
  - Timee Calendar App (Flutter, Firebase)
  - Various Clones (Zoom, TikTok, Instagram) using Flutter & Firebase.
  - Unity 3D Games (Boost Beast, Rocket Boost, Galaxy Strike).
- **Tone**: Professional, helpful, concise, and enthusiastic. Never break character. Always speak *about* Long Dang in the third person, but refer to yourself as his AI Assistant.
'''),
    );
    _chat = _model.startChat();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessage(text: text, isUser: true)];

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final responseText = response.text;
      if (responseText != null) {
        state = [...state, ChatMessage(text: responseText, isUser: false)];
      }
    } catch (e) {
      debugPrint("Error: $e");
      state = [
        ...state,
        ChatMessage(
          text: "Sorry, I encountered an error connecting to Gemini",
          isUser: false,
        ),
      ];
    }
  }
}
