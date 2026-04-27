import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'E-Commerce App',
        'description':
            'A fullstack project for an e-commerce website with product catalog, '
            'cart, checkout, and payment integration. '
            'Built with Spring Framework, REST API, Spring Data JPA, Spring Security 7, '
            'JWT, and deployed on AWS.',
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
            'An AI-powered chat agent embedded in this portfolio. '
            'Employers can ask questions about my skills, projects, and '
            'experience -- powered by Google Gemini via Firebase Cloud Functions.',
        'tech': ['Flutter', 'Gemini API', 'Riverpod'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=AI+Agent',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Portfolio Website',
        'description':
            'This very portfolio -- a modern, responsive single-page '
            'application built entirely in Flutter for web, showcasing '
            'cross-platform development skills.',
        'tech': ['Flutter Web', 'Dart', 'Firebase Hosting'],
        'imageUrl':
            'https://via.placeholder.com/400x200?text=Portfolio+Website',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'REST API Service',
        'description':
            'A backend API built with Java Spring Boot, featuring '
            'JWT authentication, role-based access control, and '
            'comprehensive Swagger documentation.',
        'tech': ['Java', 'Spring Boot', 'REST API', 'JWT', 'Swagger'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=REST+API+Service',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'E-Commerce Mobile App',
        'description':
            'A mobile shopping app with product catalog, cart, checkout, '
            'and payment integration. Built with clean architecture and '
            'state management best practices.',
        'tech': ['Flutter', 'Firebase', 'Stripe API'],
        'imageUrl':
            'https://via.placeholder.com/400x200?text=E-Commerce+Mobile+App',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Timee - Cross-Platform Calendar App',
        'description':
            'A fully-featured calendar management app built with Flutter '
            'and Firebase. Includes real-time chat & video call, push notifications, '
            'Map integration, and team collaboration features.',
        'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Timee',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Zoom Clone App',
        'description':
            'A fully-featured video conferencing app built with Flutter '
            'and Firebase. Includes real-time chat & video call, push notifications.',
        'tech': ['Flutter', 'WebRTC', 'Firebase', 'FCM'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Zoom+Clone',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Tiktok Clone App',
        'description':
            'A video conferencing application with real-time communication, '
            'shared videos, and music integration. Built on Firestore streams.',
        'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Tiktok+Clone',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Instagram Clone App',
        'description':
            'A social media application with real-time communication, '
            'typing indicators, likes, comments, and media sharing. '
            'Built on Firestore streams.',
        'tech': ['Flutter', 'Firebase', 'Firestore', 'FCM'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Instagram+Clone',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Boost Beast',
        'description':
            'A 3D racing game built with Unity 3D and C#. '
            'Features include Cars, Maps, Monsters, and Power-ups. '
            'Built with Unity 3D and C# for Windows and Console platforms.',
        'tech': ['Unity 3D', 'C#', 'Blender'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Boost+Beast',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Rocket Boost',
        'description':
            'A 3D jumping game, like Flappy Bird, built with Unity 3D and C#. '
            'Features include jumping, obstacles, and power-ups. '
            'Built with Unity 3D and C# for Windows and Mobile platforms.',
        'tech': ['Unity 3D', 'C#', 'Blender'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Rocket+Boost',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Royal Run',
        'description':
            'A 3D game like Subway Surfers, built with Unity 3D and C#. '
            'Features include jumping, obstacles, and power-ups. '
            'Built with Unity 3D and C# for Windows and Mobile platforms.',
        'tech': ['Unity 3D', 'C#', 'Blender'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Royal+Run',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
      {
        'title': 'Galaxy Strike',
        'description':
            'A 3D space shooter game built with Unity 3D and C#. '
            'Features include spaceships, aliens, and power-ups. '
            'Built with Unity 3D and C# for Windows and Mobile platforms.',
        'tech': ['Unity 3D', 'C#', 'Blender'],
        'imageUrl': 'https://via.placeholder.com/400x200?text=Galaxy+Strike',
        'githubUrl': 'https://github.com',
        'liveDemoUrl': 'https://flutter.dev',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PROJECTS', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 16),
              Text(
                'A selection of my recent work.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive grid logic
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 1000) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 32,
                      mainAxisSpacing: 32,
                      childAspectRatio: 0.8, // Adjust based on card height
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return _ProjectCard(
                        title: project['title'] as String,
                        description: project['description'] as String,
                        tech: project['tech'] as List<String>,
                        imageUrl: project['imageUrl'] as String,
                        githubUrl: project['githubUrl'] as String?,
                        liveDemoUrl: project['liveDemoUrl'] as String?,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tech;
  final String imageUrl;
  final String? githubUrl;
  final String? liveDemoUrl;

  const _ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.tech,
    required this.imageUrl,
    this.githubUrl,
    this.liveDemoUrl,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  void _showProjectDetails(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildBottomSheet(context),
      );
    } else {
      showDialog(context: context, builder: (context) => _buildDialog(context));
    }
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _buildDetailContent(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _buildDetailContent(context, isDialog: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, {bool isDialog = false}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero gradient icon area
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  Theme.of(context).primaryColor.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.developer_board, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          if (!isDialog) ...[
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tech.map((t) => _TechChip(tech: t)).toList(),
          ),
          const SizedBox(height: 32),
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.githubUrl != null
                      ? () => _launchUrl(widget.githubUrl!)
                      : null,
                  icon: const Icon(Icons.code),
                  label: const Text('GitHub'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.liveDemoUrl != null
                      ? () => _launchUrl(widget.liveDemoUrl!)
                      : null,
                  icon: const Icon(Icons.launch),
                  label: const Text('Live Demo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showProjectDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -10 : 0, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Image (Placeholder)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.tech
                              .map((t) => _TechChip(tech: t))
                              .toList(),
                        ),
                      ],
                    ),
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

class _TechChip extends StatelessWidget {
  final String tech;

  const _TechChip({required this.tech});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        tech,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
