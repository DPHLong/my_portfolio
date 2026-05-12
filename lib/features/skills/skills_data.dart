import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/models/skill.dart';

class SkillCategory {
  final String name;
  final FaIconData icon;
  final String description;
  final List<Skill> skills;

  const SkillCategory({
    required this.name,
    required this.icon,
    required this.description,
    required this.skills,
  });
}

class SkillsData {
  SkillsData._();

  static const List<SkillCategory> categories = [
    SkillCategory(
      name: 'Mobile Development',
      icon: FontAwesomeIcons.mobile,
      description: 'Building cross-platform mobile apps',
      skills: [
        Skill(name: 'Flutter', category: 'Mobile', proficiency: 0.95),
        Skill(name: 'Dart', category: 'Mobile', proficiency: 0.90),
        Skill(name: 'Android (Native)', category: 'Mobile', proficiency: 0.65),
        Skill(name: 'iOS Development', category: 'Mobile', proficiency: 0.55),
      ],
    ),
    SkillCategory(
      name: 'Backend & Cloud',
      icon: FontAwesomeIcons.cloud,
      description: 'Server-side and cloud services',
      skills: [
        Skill(name: 'Firebase', category: 'Backend', proficiency: 0.90),
        Skill(name: 'Firestore', category: 'Backend', proficiency: 0.90),
        Skill(name: 'Cloud Functions', category: 'Backend', proficiency: 0.75),
        Skill(name: 'REST APIs', category: 'Backend', proficiency: 0.80),
      ],
    ),
    SkillCategory(
      name: 'Programming Languages',
      icon: FontAwesomeIcons.code,
      description: 'Languages I work with',
      skills: [
        Skill(name: 'Dart', category: 'Languages', proficiency: 0.90),
        Skill(name: 'Java', category: 'Languages', proficiency: 0.80),
        Skill(name: 'C#', category: 'Languages', proficiency: 0.70),
        Skill(name: 'Python', category: 'Languages', proficiency: 0.55),
      ],
    ),
    SkillCategory(
      name: 'AI & Machine Learning',
      icon: FontAwesomeIcons.robot,
      description: 'Currently expanding my expertise',
      skills: [
        Skill(name: 'Prompt Engineering', category: 'AI', proficiency: 0.65),
        Skill(name: 'LLM Integration', category: 'AI', proficiency: 0.55),
        Skill(name: 'Google Gemini API', category: 'AI', proficiency: 0.50),
        Skill(name: 'AI App Architecture', category: 'AI', proficiency: 0.45),
      ],
    ),
    SkillCategory(
      name: 'Tools & Practices',
      icon: FontAwesomeIcons.toolbox,
      description: 'Development workflow and tools',
      skills: [
        Skill(name: 'Git & GitHub', category: 'Tools', proficiency: 0.90),
        Skill(name: 'CI/CD', category: 'Tools', proficiency: 0.70),
        Skill(name: 'Agile / Scrum', category: 'Tools', proficiency: 0.75),
        Skill(name: 'Clean Architecture', category: 'Tools', proficiency: 0.80),
      ],
    ),
    SkillCategory(
      name: 'IT Support',
      icon: FontAwesomeIcons.networkWired,
      description: 'IT Support',
      skills: [
        Skill(
          name: 'Ticketing Systems',
          category: 'IT Support',
          proficiency: 0.50,
        ),
        Skill(
          name: 'Hardware Troubleshooting',
          category: 'IT Support',
          proficiency: 0.70,
        ),
        Skill(
          name: 'Software Troubleshooting',
          category: 'IT Support',
          proficiency: 0.90,
        ),
        Skill(
          name: 'Network Troubleshooting',
          category: 'IT Support',
          proficiency: 0.50,
        ),
      ],
    ),
  ];
}
