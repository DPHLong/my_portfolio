import 'package:flutter/material.dart';
import 'package:my_portfolio/features/skills/widgets/section_heading.dart';
import 'package:my_portfolio/features/skills/widgets/skill_categories_grid.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SectionHeading(theme: theme),
        const SizedBox(height: 48),
        SkillCategoriesGrid(theme: theme),
      ],
    );
  }
}
