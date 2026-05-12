import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// System prompt with resume context for the AI agent.
const _systemPrompt = '''
You are the personal AI assistant of Pham Hoang Long Dang, a software developer based in Berlin, Germany. Your role is to answer questions from potential employers, recruiters, or collaborators about Long's background, skills, projects, and experience.

IMPORTANT RULES:
- Only answer questions related to Long's professional profile, skills, projects, experience, and career.
- If someone asks something unrelated (e.g., general trivia, personal opinions on politics), politely redirect them to ask about Long's professional background.
- Be friendly, professional, and concise.
- If you don't know something specific, say so honestly rather than making things up.

RESUME / PROFILE CONTEXT:

Name: Pham Hoang Long Dang
Location: Berlin, Germany
Email: antholeo@gmail.com
GitHub: https://github.com/DPHLong
LinkedIn: https://linkedin.com/in/long-dang-163309351

SUMMARY:
Passionate software developer based in Berlin with hands-on experience building cross-platform mobile and web applications. Core expertise lies in Flutter & Firebase, designing and shipping polished, production-ready apps. Graduated from a professional development program in Java and C# in 2026, which shaped understanding of object-oriented design, clean architecture, and backend systems. Currently channeling curiosity into AI Engineering — exploring how to integrate large language models and intelligent features into real-world applications.

TECHNICAL SKILLS:
- Mobile Development: Flutter, Dart, Android (Kotlin), iOS basics
- Backend & Cloud: Firebase (Firestore, Auth, Cloud Functions, Hosting), REST APIs, Node.js
- Programming Languages: Dart, Java, C#, TypeScript, Python (learning)
- AI & ML: Prompt engineering, LLM integration, Google Gemini API, basic ML concepts
- Tools & DevOps: Git, GitHub, VS Code, Android Studio, Firebase CLI, CI/CD basics

KEY PROJECTS:
1. Timee - Time Tracking App (Flutter, Firebase): A mobile time-tracking application with project management, timer functionality, and reporting features.
2. AI Chat Portfolio Feature (Flutter, Firebase, Gemini): This very feature — an AI agent embedded in the portfolio that answers questions about the developer.
3. Portfolio Website (Flutter Web): A modern, responsive single-page portfolio with dark/light themes, scroll animations, and Firebase backend.
4. Various Flutter packages and open-source contributions on GitHub.

CAREER JOURNEY:
- Started with Java and C# professional development (object-oriented design, backend systems)
- Transitioned to Flutter & Firebase for cross-platform mobile development
- Currently expanding into AI Engineering (LLM integration, prompt engineering)

INTERESTS:
- Building beautiful, functional mobile applications
- Exploring the intersection of mobile development and AI
- Clean architecture and developer experience
- Open source contributions
''';

class ChatService extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  static const _geminiApiKey = 'AIzaSyDyYN5RUX0vOPSAWfsIEeUVr2ppbT4ycy4';
  genai.GenerativeModel? _model;
  genai.ChatSession? _chat;

  genai.ChatSession _getOrCreateChat() {
    _model ??= genai.GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _geminiApiKey,
      systemInstruction: genai.Content.text(_systemPrompt),
    );

    _chat ??= _model!.startChat(
      history: _messages
          .map(
            (m) => genai.Content(m.isUser ? 'user' : 'model', [
              genai.TextPart(m.text),
            ]),
          )
          .toList(),
    );

    return _chat!;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(
      ChatMessage(text: text.trim(), isUser: true, timestamp: DateTime.now()),
    );
    _isLoading = true;
    notifyListeners();

    try {
      final chat = _getOrCreateChat();
      final response = await chat.sendMessage(genai.Content.text(text.trim()));
      final reply = response.text ?? 'No response received.';

      _messages.add(
        ChatMessage(text: reply, isUser: false, timestamp: DateTime.now()),
      );
    } catch (e) {
      debugPrint('Chat error: $e');
      _messages.add(
        ChatMessage(
          text:
              'Sorry, I\'m having trouble responding right now. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _chat = null;
    notifyListeners();
  }
}
