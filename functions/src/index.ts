import {onCall, HttpsError} from "firebase-functions/v2/https";
import {GoogleGenerativeAI} from "@google/generative-ai";
import {defineString} from "firebase-functions/params";

// ── Rate limiting store (in-memory, resets on cold start) ────────────
const rateLimitMap = new Map<string, {count: number; resetAt: number}>();
const RATE_LIMIT = 10; // requests per window
const RATE_WINDOW_MS = 60 * 1000; // 1 minute

// ── Gemini API key from Firebase environment config ──────────────────
const geminiApiKey = defineString("GEMINI_API_KEY");

// ── System prompt with resume context ────────────────────────────────
const SYSTEM_PROMPT = `You are the personal AI assistant of Pham Hoang Long Dang, a software developer based in Berlin, Germany. Your role is to answer questions from potential employers, recruiters, or collaborators about Long's background, skills, projects, and experience.

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
`;

/**
 * Sanitize user input to prevent prompt injection attacks.
 */
function sanitizeInput(input: string): string {
  // Remove potential prompt injection patterns
  let sanitized = input
    .replace(/^(system|assistant|user):/gmi, "")
    .replace(/\[INST\]|\[\/INST\]/gi, "")
    .replace(/<\/?s>/gi, "");

  // Truncate to reasonable length
  if (sanitized.length > 500) {
    sanitized = sanitized.substring(0, 500);
  }

  return sanitized.trim();
}

/**
 * Check rate limit for a given IP address.
 */
function checkRateLimit(ip: string): boolean {
  const now = Date.now();
  const entry = rateLimitMap.get(ip);

  if (!entry || now > entry.resetAt) {
    rateLimitMap.set(ip, {count: 1, resetAt: now + RATE_WINDOW_MS});
    return true;
  }

  if (entry.count >= RATE_LIMIT) {
    return false;
  }

  entry.count++;
  return true;
}

// ── Cloud Function: askAgent ─────────────────────────────────────────
export const askAgent = onCall(
  {
    region: "europe-west1",
    maxInstances: 10,
    cors: true,
  },
  async (request) => {
    // ── Rate limiting ──
    const ip = request.rawRequest.ip || "unknown";
    if (!checkRateLimit(ip)) {
      throw new HttpsError(
        "resource-exhausted",
        "Too many requests. Please wait a moment before trying again."
      );
    }

    // ── Validate input ──
    const message = request.data?.message;
    if (!message || typeof message !== "string" || message.trim().length === 0) {
      throw new HttpsError(
        "invalid-argument",
        "Please provide a message."
      );
    }

    const sanitizedMessage = sanitizeInput(message);

    // ── Conversation history (optional) ──
    const history: Array<{role: string; text: string}> =
      request.data?.history || [];

    try {
      const genAI = new GoogleGenerativeAI(geminiApiKey.value());
      const model = genAI.getGenerativeModel({model: "gemini-2.0-flash"});

      // Build chat history for context
      const chatHistory = history.slice(-10).map((msg) => ({
        role: msg.role === "user" ? "user" as const : "model" as const,
        parts: [{text: msg.text}],
      }));

      const chat = model.startChat({
        history: chatHistory,
        systemInstruction: SYSTEM_PROMPT,
      });

      const result = await chat.sendMessage(sanitizedMessage);
      const response = result.response.text();

      return {reply: response};
    } catch (error) {
      console.error("Gemini API error:", error);
      throw new HttpsError(
        "internal",
        "Sorry, I'm having trouble responding right now. Please try again later."
      );
    }
  }
);
