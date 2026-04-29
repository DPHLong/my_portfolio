import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ABOUT ME', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 20),
              // Avatar holder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildBio(context)),
                        const SizedBox(width: 64),
                        Expanded(child: _buildSkills(context)),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBio(context),
                      const SizedBox(height: 64),
                      _buildSkills(context),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Journey', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        Text(
          'I\'m a passionate software developer based in Berlin, Germany, '
          'with hands-on experience building cross-platform mobile and web '
          'applications. My core expertise lies in Flutter & Firebase, '
          'where I design and ship polished, production-ready apps.\n\n'
          'In 2026, I graduated from a professional development in Java and C#, '
          'which shaped my understanding of object-oriented design, clean '
          'architecture, and backend systems.\n\n'
          'Now I\'m channeling my curiosity into AI Engineering -- exploring '
          'how to integrate large language models and intelligent features '
          'into real-world applications. I believe the intersection of '
          'mobile development and AI is where the most exciting products '
          'will be built.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSkills(BuildContext context) {
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
                      .map((skill) => _SkillChip(skill: skill))
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

class _SkillChip extends StatelessWidget {
  final String skill;

  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        skill,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
      ),
    );
  }
}
