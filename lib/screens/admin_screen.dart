import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isUploading = false;

  Future<void> _uploadData() async {
    setState(() => _isUploading = true);
    final firestore = FirebaseFirestore.instance;
    
    try {
      // 1. Upload Experiences
      final experiences = [
        {
          'role': 'Further training in AI-Engineering',
          'company': 'Private Learning',
          'duration': '2026 - Now',
          'description': 'Exploring LLMs, prompt engineering, and integrating intelligent features into real-world apps.',
          'tech': ['Python', 'LLM', 'Prompt Engineering', 'AI Agents'],
        },
        {
          'role': 'Further training in Java, C#, MySQL',
          'company': 'IHK Berlin',
          'duration': '2025 - 2026',
          'description': 'Focused on deepening object-oriented programming skills with Java and C# and mastering database management with MySQL. \nLearned about clean architecture, system design, and full-stack development principles.',
          'tech': ['Java', 'C#', 'MySQL', 'Git', 'Spring Boot', 'Unity'],
        },
        {
          'role': 'Flutter Developer',
          'company': 'Timee GmbH',
          'duration': '2022 - 2025',
          'description': 'Designed and maintained cross-platform mobile applications using Flutter and Firebase. \nImplemented features for all-in-one calendar and appointment management app.\nFeatures include: calendar and event management, real-time chat and video calls, reminder system, and user authentication.',
          'tech': ['Flutter', 'Firebase', 'Dart', 'Git'],
        },
        {
          'role': 'Junior Android Developer Intern',
          'company': 'Benefit GmbH',
          'duration': '2018 - 2019',
          'description': 'Assisted in the development of a new tool for shopping and ordering. \nImplemented features for data storage and simplified access for cashiers. \nLearned about the full development lifecycle from planning to deployment.',
          'tech': ['Java', 'Android', 'Git'],
        },
        {
          'role': 'Student in Software Engineering',
          'company': 'FU Berlin',
          'duration': '2018 - 2022',
          'description': 'Focus on fundamental computer science principles including data structures, algorithms, and software architecture.',
          'tech': ['Java', 'C++', 'Data Structures', 'Algorithms', 'Software Architecture', 'Databases'],
        },
      ];
      
      int expOrder = 0;
      for (var exp in experiences) {
        await firestore.collection('experiences').add({
          ...exp,
          'order': expOrder++,
        });
      }

      // 2. Upload Projects
      final projects = [
        {
          'title': 'E-Commerce App',
          'description': 'A fullstack project for an e-commerce website with product catalog, cart, checkout, and payment integration. Built with Spring Framework, REST API, Spring Data JPA, Spring Security 7, JWT, and deployed on AWS.',
          'tech': ['Spring Boot', 'REST API', 'Spring Data JPA', 'Spring Security 7', 'JWT', 'AWS'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=E-Commerce+App',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'AI Agent',
          'description': 'An AI-powered chat agent embedded in this portfolio. Employers can ask questions about my skills, projects, and experience -- powered by Google Gemini via Firebase Cloud Functions.',
          'tech': ['Flutter', 'Gemini API', 'Riverpod'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=AI+Agent',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Portfolio Website',
          'description': 'This very portfolio -- a modern, responsive single-page application built entirely in Flutter for web, showcasing cross-platform development skills.',
          'tech': ['Flutter Web', 'Dart', 'Firebase Hosting'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Portfolio+Website',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'REST API Service',
          'description': 'A backend API built with Java Spring Boot, featuring JWT authentication, role-based access control, and comprehensive Swagger documentation.',
          'tech': ['Java', 'Spring Boot', 'REST API', 'JWT', 'Swagger'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=REST+API+Service',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'E-Commerce Mobile App',
          'description': 'A mobile shopping app with product catalog, cart, checkout, and payment integration. Built with clean architecture and state management best practices.',
          'tech': ['Flutter', 'Firebase', 'Stripe API'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=E-Commerce+Mobile+App',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Timee - Cross-Platform Calendar App',
          'description': 'A fully-featured calendar management app built with Flutter and Firebase. Includes real-time chat & video call, push notifications, Map integration, and team collaboration features.',
          'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Timee',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Zoom Clone App',
          'description': 'A fully-featured video conferencing app built with Flutter and Firebase. Includes real-time chat & video call, push notifications.',
          'tech': ['Flutter', 'WebRTC', 'Firebase', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Zoom+Clone',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Tiktok Clone App',
          'description': 'A video conferencing application with real-time communication, shared videos, and music integration. Built on Firestore streams.',
          'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Tiktok+Clone',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Instagram Clone App',
          'description': 'A social media application with real-time communication, typing indicators, likes, comments, and media sharing. Built on Firestore streams.',
          'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Instagram+Clone',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Boost Beast',
          'description': 'A 3D racing game built with Unity 3D and C#. Features include Cars, Maps, Monsters, and Power-ups. Built with Unity 3D and C# for Windows and Console platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Boost+Beast',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Rocket Boost',
          'description': 'A 3D jumping game, like Flappy Bird, built with Unity 3D and C#. Features include jumping, obstacles, and power-ups. Built with Unity 3D and C# for Windows and Mobile platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Rocket+Boost',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Royal Run',
          'description': 'A 3D game like Subway Surfers, built with Unity 3D and C#. Features include jumping, obstacles, and power-ups. Built with Unity 3D and C# for Windows and Mobile platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Royal+Run',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Galaxy Strike',
          'description': 'A 3D space shooter game built with Unity 3D and C#. Features include spaceships, aliens, and power-ups. Built with Unity 3D and C# for Windows and Mobile platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Galaxy+Strike',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
      ];
      
      int projOrder = 0;
      for (var proj in projects) {
        await firestore.collection('projects').add({
          ...proj,
          'order': projOrder++,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload Complete! Check Firebase Console.')));
      }
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin / Migration')),
      body: Center(
        child: _isUploading 
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _uploadData,
              child: const Text('Upload Mock Data to Firestore'),
            ),
      ),
    );
  }
}
