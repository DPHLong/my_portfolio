import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const _AdminDashboard();
        } else {
          return const _LoginScreen();
        }
      },
    );
  }
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message ?? 'Login failed',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.admin_panel_settings, size: 64),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Admin Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminDashboard extends StatefulWidget {
  const _AdminDashboard();

  @override
  State<_AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<_AdminDashboard> {
  bool _isUploading = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _deleteMessage(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('messages').doc(id).delete();
    }
  }

  void _showMessageDetails(Map<String, dynamic> data, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message from ${data['name']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Email: ${data['email']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Subject: ${data['subject']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text(data['message'] ?? ''),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMessage(docId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Message'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

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
          'description':
              'Exploring LLMs, prompt engineering, and integrating intelligent features into real-world apps.',
          'tech': ['Python', 'LLM', 'Prompt Engineering', 'AI Agents'],
        },
        {
          'role': 'Further training in Java, C#, MySQL',
          'company': 'IHK Berlin',
          'duration': '2025 - 2026',
          'description':
              'Focused on deepening object-oriented programming skills with Java and C# and mastering database management with MySQL. \nLearned about clean architecture, system design, and full-stack development principles.',
          'tech': ['Java', 'C#', 'MySQL', 'Git', 'Spring Boot', 'Unity'],
        },
        {
          'role': 'Flutter Developer',
          'company': 'Timee GmbH',
          'duration': '2022 - 2025',
          'description':
              'Designed and maintained cross-platform mobile applications using Flutter and Firebase. \nImplemented features for all-in-one calendar and appointment management app.\nFeatures include: calendar and event management, real-time chat and video calls, reminder system, and user authentication.',
          'tech': ['Flutter', 'Firebase', 'Dart', 'Git'],
        },
        {
          'role': 'Junior Android Developer Intern',
          'company': 'Benefit GmbH',
          'duration': '2018 - 2019',
          'description':
              'Assisted in the development of a new tool for shopping and ordering. \nImplemented features for data storage and simplified access for cashiers. \nLearned about the full development lifecycle from planning to deployment.',
          'tech': ['Java', 'Android', 'Git'],
        },
        {
          'role': 'Student in Software Engineering',
          'company': 'FU Berlin',
          'duration': '2018 - 2022',
          'description':
              'Focus on fundamental computer science principles including data structures, algorithms, and software architecture.',
          'tech': [
            'Java',
            'C++',
            'Data Structures',
            'Algorithms',
            'Software Architecture',
            'Databases',
          ],
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
          'description':
              'A fullstack project for an e-commerce website with product catalog, cart, checkout, and payment integration. Built with Spring Framework, REST API, Spring Data JPA, Spring Security 7, JWT, and deployed on AWS.',
          'tech': [
            'Spring Boot',
            'REST API',
            'Spring Data JPA',
            'Spring Security 7',
            'JWT',
            'AWS',
          ],
          'imageUrl': 'https://via.placeholder.com/400x200?text=E-Commerce+App',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'AI Agent',
          'description':
              'An AI-powered chat agent embedded in this portfolio. Employers can ask questions about my skills, projects, and experience -- powered by Google Gemini via Firebase Cloud Functions.',
          'tech': ['Flutter', 'Gemini API', 'Riverpod'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=AI+Agent',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Portfolio Website',
          'description':
              'This very portfolio -- a modern, responsive single-page application built entirely in Flutter for web, showcasing cross-platform development skills.',
          'tech': ['Flutter Web', 'Dart', 'Firebase Hosting'],
          'imageUrl':
              'https://via.placeholder.com/400x200?text=Portfolio+Website',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'REST API Service',
          'description':
              'A backend API built with Java Spring Boot, featuring JWT authentication, role-based access control, and comprehensive Swagger documentation.',
          'tech': ['Java', 'Spring Boot', 'REST API', 'JWT', 'Swagger'],
          'imageUrl':
              'https://via.placeholder.com/400x200?text=REST+API+Service',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'E-Commerce Mobile App',
          'description':
              'A mobile shopping app with product catalog, cart, checkout, and payment integration. Built with clean architecture and state management best practices.',
          'tech': ['Flutter', 'Firebase', 'Stripe API'],
          'imageUrl':
              'https://via.placeholder.com/400x200?text=E-Commerce+Mobile+App',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Timee - Cross-Platform Calendar App',
          'description':
              'A fully-featured calendar management app built with Flutter and Firebase. Includes real-time chat & video call, push notifications, Map integration, and team collaboration features.',
          'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Timee',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Zoom Clone App',
          'description':
              'A fully-featured video conferencing app built with Flutter and Firebase. Includes real-time chat & video call, push notifications.',
          'tech': ['Flutter', 'WebRTC', 'Firebase', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Zoom+Clone',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Tiktok Clone App',
          'description':
              'A video conferencing application with real-time communication, shared videos, and music integration. Built on Firestore streams.',
          'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Tiktok+Clone',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Instagram Clone App',
          'description':
              'A social media application with real-time communication, typing indicators, likes, comments, and media sharing. Built on Firestore streams.',
          'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
          'imageUrl':
              'https://via.placeholder.com/400x200?text=Instagram+Clone',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Boost Beast',
          'description':
              'A 3D racing game built with Unity 3D and C#. Features include Cars, Maps, Monsters, and Power-ups. Built with Unity 3D and C# for Windows and Console platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Boost+Beast',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Rocket Boost',
          'description':
              'A 3D jumping game, like Flappy Bird, built with Unity 3D and C#. Features include jumping, obstacles, and power-ups. Built with Unity 3D and C# for Windows and Mobile platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Rocket+Boost',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Royal Run',
          'description':
              'A 3D game like Subway Surfers, built with Unity 3D and C#. Features include jumping, obstacles, and power-ups. Built with Unity 3D and C# for Windows and Mobile platforms.',
          'tech': ['Unity 3D', 'C#', 'Blender'],
          'imageUrl': 'https://via.placeholder.com/400x200?text=Royal+Run',
          'githubUrl': 'https://github.com',
          'liveDemoUrl': 'https://flutter.dev',
        },
        {
          'title': 'Galaxy Strike',
          'description':
              'A 3D space shooter game built with Unity 3D and C#. Features include spaceships, aliens, and power-ups. Built with Unity 3D and C# for Windows and Mobile platforms.',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload Complete! Check Firebase Console.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dt = timestamp.toDate();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: 'Upload Mock Data',
            onPressed: _isUploading ? null : _uploadData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isUploading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search messages (Name or Email)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) =>
                  setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading messages: ${snapshot.error}'),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final email = (data['email'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text('No messages found.'));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            data['name']?.substring(0, 1).toUpperCase() ?? '?',
                          ),
                        ),
                        title: Text(data['name'] ?? 'Unknown'),
                        subtitle: Text(
                          '${data['subject'] ?? ''}\n${_formatDate(data['timestamp'] as Timestamp?)}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMessage(doc.id),
                        ),
                        onTap: () => _showMessageDetails(data, doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
