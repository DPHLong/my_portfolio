import {onCall, HttpsError} from "firebase-functions/v2/https";
import {GoogleGenerativeAI} from "@google/generative-ai";
import {defineString} from "firebase-functions/params";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

admin.initializeApp();
const db = admin.firestore();

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
      const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        systemInstruction: SYSTEM_PROMPT,
      });

      // Build chat history for context
      const chatHistory = history.slice(-10).map((msg) => ({
        role: msg.role === "user" ? "user" as const : "model" as const,
        parts: [{text: msg.text}],
      }));

      const chat = model.startChat({
        history: chatHistory,
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

// ── Email config from Firebase environment ───────────────────────────
const gmailUser = defineString("GMAIL_USER");
const gmailAppPassword = defineString("GMAIL_APP_PASSWORD");

// ── Contact form anti-spam: per-email rate limit ─────────────────────
const CONTACT_RATE_LIMIT = 3; // max messages per window
const CONTACT_RATE_WINDOW_MS = 10 * 60 * 1000; // 10 minutes

// ── Cloud Function: sendContactMessage ───────────────────────────────
export const sendContactMessage = onCall(
  {
    region: "europe-west1",
    maxInstances: 5,
    cors: true,
  },
  async (request) => {
    // ── Validate input ──
    const {name, email, message} = request.data || {};

    if (!name || typeof name !== "string" || name.trim().length === 0) {
      throw new HttpsError("invalid-argument", "Please provide your name.");
    }
    if (!email || typeof email !== "string" || email.trim().length === 0) {
      throw new HttpsError("invalid-argument", "Please provide your email.");
    }
    if (!message || typeof message !== "string" || message.trim().length === 0) {
      throw new HttpsError("invalid-argument", "Please provide a message.");
    }

    // Basic email format check
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.trim())) {
      throw new HttpsError("invalid-argument", "Please provide a valid email.");
    }

    const trimmedName = name.trim().substring(0, 100);
    const trimmedEmail = email.trim().substring(0, 200);
    const trimmedMessage = message.trim().substring(0, 2000);

    // ── Anti-spam: check recent messages from the same email ──
    const cutoff = new Date(Date.now() - CONTACT_RATE_WINDOW_MS);
    const recentSnapshot = await db
      .collection("contact_messages")
      .where("email", "==", trimmedEmail)
      .where("timestamp", ">=", admin.firestore.Timestamp.fromDate(cutoff))
      .get();

    if (recentSnapshot.size >= CONTACT_RATE_LIMIT) {
      throw new HttpsError(
        "resource-exhausted",
        "You've sent too many messages recently. Please try again later."
      );
    }

    // ── IP-based rate limiting ──
    const ip = request.rawRequest.ip || "unknown";
    if (!checkRateLimit(ip)) {
      throw new HttpsError(
        "resource-exhausted",
        "Too many requests. Please wait a moment before trying again."
      );
    }

    // ── Save to Firestore ──
    await db.collection("contact_messages").add({
      name: trimmedName,
      email: trimmedEmail,
      message: trimmedMessage,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      ip: ip,
    });

    // ── Send email notification ──
    try {
      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
          user: gmailUser.value(),
          pass: gmailAppPassword.value(),
        },
      });

      await transporter.sendMail({
        from: `"Portfolio Contact" <${gmailUser.value()}>`,
        to: "antholeo@gmail.com",
        replyTo: trimmedEmail,
        subject: `Portfolio Contact: ${trimmedName}`,
        text:
          `New contact message from your portfolio:\n\n` +
          `Name: ${trimmedName}\n` +
          `Email: ${trimmedEmail}\n\n` +
          `Message:\n${trimmedMessage}`,
        html:
          `<h2>New Contact Message</h2>` +
          `<p><strong>Name:</strong> ${escapeHtml(trimmedName)}</p>` +
          `<p><strong>Email:</strong> ${escapeHtml(trimmedEmail)}</p>` +
          `<hr/>` +
          `<p><strong>Message:</strong></p>` +
          `<p>${escapeHtml(trimmedMessage).replace(/\n/g, "<br/>")}</p>`,
      });
    } catch (emailError) {
      // Log but don't fail the request — the message is already saved
      console.error("Failed to send email notification:", emailError);
    }

    return {success: true};
  }
);

/**
 * Escape HTML special characters to prevent XSS in email body.
 */
function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
