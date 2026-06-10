import 'package:flutter/material.dart';
import 'package:my_portfolio/features/skills/widgets/skill_chip.dart';

class SkillsWidget extends StatelessWidget {
  const SkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final skillCategories = {
      'Frontend': ['Flutter', 'Dart', 'Unity', 'Responsive Design'],
      'Backend & DB': ['Java', 'C#', 'Firebase', 'MySQL', 'AWS'],
      'AI & Emerging': ['LLM Integration', 'Prompt Engineering', 'AI Agents'],
      'Tools': ['Git', 'CI/CD', 'Scrum', 'Agile', 'Postman', 'Figma'],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technical Skills',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        ...skillCategories.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: entry.value
                      .map((skill) => SkillChip(skill: skill))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
