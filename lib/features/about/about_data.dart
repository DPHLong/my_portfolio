import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JourneyMilestone {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  const JourneyMilestone({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}

class TechItem {
  final String name;
  final IconData icon;
  final Color color;

  const TechItem({required this.name, required this.icon, required this.color});
}

class AboutData {
  AboutData._();

  static const List<JourneyMilestone> journey = [
    JourneyMilestone(
      title: 'Flutter & Firebase',
      subtitle: 'Core expertise',
      description:
          'Specialized in building cross-platform mobile and web '
          'applications with production-ready quality.',
      icon: Icons.phone_android_rounded,
    ),
    JourneyMilestone(
      title: 'Java & C#',
      subtitle: 'Further training',
      description:
          'Built a solid foundation in object-oriented programming, '
          'clean architecture, and backend systems.',
      icon: Icons.code_rounded,
    ),
    JourneyMilestone(
      title: 'AI Engineering',
      subtitle: 'Current focus',
      description:
          'Exploring LLMs, prompt engineering, and integrating '
          'intelligent features into real-world apps.',
      icon: Icons.psychology_rounded,
    ),
  ];

  static const List<TechItem> techStack = [
    TechItem(
      name: 'Flutter',
      icon: FontAwesomeIcons.flutter,
      color: Color(0xFF02569B),
    ),
    TechItem(
      name: 'Dart',
      icon: FontAwesomeIcons.bullseye,
      color: Color(0xFF0175C2),
    ),
    TechItem(
      name: 'Firebase',
      icon: FontAwesomeIcons.fire,
      color: Color(0xFFFFCA28),
    ),
    TechItem(
      name: 'Java',
      icon: FontAwesomeIcons.java,
      color: Color(0xFFE76F00),
    ),
    TechItem(
      name: 'C#',
      icon: FontAwesomeIcons.hashtag,
      color: Color(0xFF68217A),
    ),
    TechItem(
      name: 'Python',
      icon: FontAwesomeIcons.python,
      color: Color(0xFF3776AB),
    ),
    TechItem(
      name: 'Unity',
      icon: FontAwesomeIcons.unity,
      color: Color.fromARGB(255, 61, 61, 61),
    ),
    TechItem(
      name: 'AI / ML',
      icon: FontAwesomeIcons.robot,
      color: Color(0xFF00BFA5),
    ),
    TechItem(name: 'Git', icon: FontAwesomeIcons.git, color: Color(0xFFF05032)),
  ];
}
