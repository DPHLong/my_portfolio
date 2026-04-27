import 'package:my_portfolio/data/models/project.dart';

class ProjectData {
  ProjectData._();

  static const List<String> categories = [
    'All',
    'Mobile',
    'Web',
    'AI / ML',
    'Backend',
    'Game',
  ];

  static const List<Project> projects = [
    Project(
      title: 'AI Portfolio Assistant',
      description:
          'An AI-powered chat agent embedded in this portfolio. '
          'Employers can ask questions about my skills, projects, and '
          'experience -- powered by Google Gemini via Firebase Cloud Functions.',
      imageAsset: 'assets/images/project_ai_chat.png',
      technologies: ['Flutter', 'Firebase', 'Gemini API', 'Cloud Functions'],
      category: 'AI / ML',
      featured: true,
    ),
    Project(
      title: 'Portfolio Website',
      description:
          'This very portfolio -- a modern, responsive single-page '
          'application built entirely in Flutter for web, showcasing '
          'cross-platform development skills.',
      imageAsset: 'assets/images/project_portfolio.png',
      technologies: ['Flutter Web', 'Dart', 'Firebase Hosting'],
      category: 'Web',
    ),
    Project(
      title: 'E-Commerce Web',
      description:
          'A fullstack project for an e-commerce website with product catalog, '
          'cart, checkout, and payment integration. '
          'Built with Spring Framework, REST API, Spring Data JPA, Spring Security 7, '
          'JWT, and deployed on AWS.',
      imageAsset: 'assets/images/project_ecommerce.png',
      technologies: [
        'Spring Framework',
        'REST API',
        'Spring Data JPA',
        'Spring Security 7',
        'JWT',
        'AWS',
      ],
      category: 'Web',
      featured: true,
    ),
    Project(
      title: 'REST API Service',
      description:
          'A backend API built with Java Spring Boot, featuring '
          'JWT authentication, role-based access control, and '
          'comprehensive Swagger documentation.',
      imageAsset: 'assets/images/project_api.png',
      technologies: ['Java', 'Spring Boot', 'MySQL'],
      category: 'Backend',
    ),
    Project(
      title: 'E-Commerce Mobile App',
      description:
          'A mobile shopping app with product catalog, cart, checkout, '
          'and payment integration. Built with clean architecture and '
          'state management best practices.',
      imageAsset: 'assets/images/project_ecommerce.png',
      technologies: ['Flutter', 'Dart', 'Firebase', 'Stripe'],
      category: 'Mobile',
    ),
    Project(
      title: 'Timee - Cross-Platform Calendar App',
      description:
          'A fully-featured calendar management app built with Flutter '
          'and Firebase. Includes real-time chat & video call, push notifications, '
          'Map integration, and team collaboration features.',
      imageAsset: 'assets/images/project_timee.png',
      technologies: ['Flutter', 'Firebase', 'Firestore', 'FCM'],
      category: 'Mobile',
      featured: true,
    ),
    Project(
      title: 'Zoom Clone App',
      description:
          'A video conferencing application with real-time communication, '
          'group video calls, and screen sharing. '
          'Built on Firestore streams.',
      imageAsset: 'assets/images/project_chat.png',
      technologies: ['Flutter', 'Firestore', 'Cloud Storage', 'FCM'],
      category: 'Mobile',
    ),
    Project(
      title: 'Tiktok Clone App',
      description:
          'A video conferencing application with real-time communication, '
          'shared videos, and music integration. '
          'Built on Firestore streams.',
      imageAsset: 'assets/images/project_tiktok.png',
      technologies: ['Flutter', 'Firestore', 'Cloud Storage', 'FCM'],
      category: 'Mobile',
    ),
    Project(
      title: 'Instagram Clone App',
      description:
          'A social media application with real-time communication, '
          'typing indicators, likes, comments, and media sharing. '
          'Built on Firestore streams.',
      imageAsset: 'assets/images/project_chat.png',
      technologies: ['Flutter', 'Firestore', 'Cloud Storage', 'FCM'],
      category: 'Mobile',
    ),
    Project(
      title: 'Boost Beast',
      description:
          'A 3D racing game built with Unity 3D and C#. '
          'Features include Cars, Maps, Monsters, and Power-ups. '
          'Built with Unity 3D and C# for Windows and Console platforms.',
      imageAsset: 'assets/images/boost_beast.png',
      technologies: ['Unity 3D', 'C#', 'Windows', 'Console'],
      category: 'Game',
      featured: true,
    ),
    Project(
      title: 'Rocket Boost',
      description:
          'A 3D jumping game, like Flappy Bird, built with Unity 3D and C#. '
          'Features include jumping, obstacles, and power-ups. '
          'Built with Unity 3D and C# for Windows and Mobile platforms.',
      imageAsset: 'assets/images/rocket_boost.png',
      technologies: ['Unity 3D', 'C#', 'Windows', 'Mobile'],
      category: 'Game',
    ),
    Project(
      title: 'Royal Run',
      description:
          'A 3D game like Subway Surfers, built with Unity 3D and C#. '
          'Features include jumping, obstacles, and power-ups. '
          'Built with Unity 3D and C# for Windows and Mobile platforms.',
      imageAsset: 'assets/images/royal_run.png',
      technologies: ['Unity 3D', 'C#', 'Windows', 'Mobile'],
      category: 'Game',
    ),
  ];
}
