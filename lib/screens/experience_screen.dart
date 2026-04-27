import 'package:flutter/material.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Focused on deepening object-oriented programming skills with Java and C# and mastering database management with MySQL. \n'
            'Learned about clean architecture, system design, and full-stack development principles.',
        'tech': ['Java', 'C#', 'MySQL', 'Git', 'Spring Boot', 'Unity'],
      },
      {
        'role': 'Flutter Developer',
        'company': 'Timee GmbH',
        'duration': '2022 - 2025',
        'description':
            'Designed and maintained cross-platform mobile applications using Flutter and Firebase. \n'
            'Implemented features for all-in-one calendar and appointment management app.\n'
            'Features include: calendar and event management, real-time chat and video calls, '
            'reminder system, and user authentication.',
        'tech': ['Flutter', 'Firebase', 'Dart', 'Git'],
      },
      {
        'role': 'Junior Android Developer Intern',
        'company': 'Benefit GmbH',
        'duration': '2018 - 2019',
        'description':
            'Assisted in the development of a new tool for shopping and ordering. \n'
            'Implemented features for data storage and simplified access for cashiers. \n'
            'Learned about the full development lifecycle from planning to deployment.',
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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EXPERIENCE',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 48),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  final exp = experiences[index];
                  return _TimelineItem(
                    isFirst: index == 0,
                    isLast: index == experiences.length - 1,
                    role: exp['role'] as String,
                    company: exp['company'] as String,
                    duration: exp['duration'] as String,
                    description: exp['description'] as String,
                    tech: exp['tech'] as List<String>,
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

class _TimelineItem extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String role;
  final String company;
  final String duration;
  final String description;
  final List<String> tech;

  const _TimelineItem({
    required this.isFirst,
    required this.isLast,
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    required this.tech,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(role, style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    company,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tech.map((t) => _TechChip(tech: t)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tech,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
      ),
    );
  }
}
