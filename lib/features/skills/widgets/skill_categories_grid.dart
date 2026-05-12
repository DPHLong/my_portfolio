import 'package:flutter/material.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/skills/skills_data.dart';
import 'package:my_portfolio/features/skills/widgets/skill_category_card.dart';

class SkillCategoriesGrid extends StatelessWidget {
  final ThemeData theme;

  const SkillCategoriesGrid({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final screenType = Responsive.getScreenType(context);

    final crossAxisCount = switch (screenType) {
      ScreenType.desktop => 2,
      ScreenType.tablet => 2,
      ScreenType.mobile => 1,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 24.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final cardWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < SkillsData.categories.length; i++)
              SizedBox(
                width: crossAxisCount == 1 ? constraints.maxWidth : cardWidth,
                child: SkillCategoryCard(
                  category: SkillsData.categories[i],
                  index: i,
                  theme: theme,
                ),
              ),
          ],
        );
      },
    );
  }
}
