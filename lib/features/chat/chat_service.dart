import 'package:cloud_functions/cloud_functions.dart';
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

  Map<String, String> toHistory() => {
    'role': isUser ? 'user' : 'model',
    'text': text,
  };
}

/// System prompt shared between debug (direct) and production (Cloud Function).
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

  // ── Production: Cloud Function ──
  final HttpsCallable _askAgent = FirebaseFunctions.instanceFor(
    region: 'europe-west1',
  ).httpsCallable('askAgent');

  // ── Debug: Direct Gemini call ──
  static const _geminiApiKey = '';
  genai.GenerativeModel? _debugModel;
  genai.ChatSession? _debugChat;

  genai.ChatSession _getOrCreateDebugChat() {
    _debugModel ??= genai.GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _geminiApiKey,
      systemInstruction: genai.Content.text(_systemPrompt),
    );

    _debugChat ??= _debugModel!.startChat(
      history: _messages
          .map(
            (m) => genai.Content(m.isUser ? 'user' : 'model', [
              genai.TextPart(m.text),
            ]),
          )
          .toList(),
    );

    return _debugChat!;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final reply = kDebugMode
          ? await _sendDirectToGemini(text.trim())
          : await _sendViaCloudFunction(text.trim());

      _messages.add(
        ChatMessage(text: reply, isUser: false, timestamp: DateTime.now()),
      );
    } catch (e) {
      debugPrint('Chat error: $e');

      String errorMessage;
      if (e is FirebaseFunctionsException && e.code == 'resource-exhausted') {
        errorMessage =
            'You\'re sending messages too quickly. Please wait a moment.';
      } else {
        errorMessage =
            'Sorry, I\'m having trouble responding right now. Please try again.';
      }

      _messages.add(
        ChatMessage(
          text: errorMessage,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Debug mode: call Gemini API directly from the client.
  Future<String> _sendDirectToGemini(String text) async {
    final chat = _getOrCreateDebugChat();
    final response = await chat.sendMessage(genai.Content.text(text));
    return response.text ?? 'No response received.';
  }

  /// Production mode: call via Firebase Cloud Function.
  Future<String> _sendViaCloudFunction(String text) async {
    final history = _messages
        .where((m) => m.isUser || !m.isUser)
        .take(_messages.length - 1) // exclude the just-added user message
        .map((m) => m.toHistory())
        .toList();

    final result = await _askAgent.call<Map<String, dynamic>>({
      'message': text,
      'history': history,
    });

    return result.data['reply'] as String? ?? 'No response received.';
  }

  void clearChat() {
    _messages.clear();
    _debugChat = null; // reset the chat session
    notifyListeners();
  }
}
