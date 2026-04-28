import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';
import 'package:my_portfolio/data/models/skill.dart';
import 'package:my_portfolio/features/skills/skills_data.dart';

class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const SkillsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: AppConstants.sectionSkills,
      globalKey: sectionKey,
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          _SectionHeading(theme: theme),
          const SizedBox(height: 48),
          _SkillCategoriesGrid(theme: theme),
        ],
      ),
    );
  }
}

// ── Section heading ───────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final ThemeData theme;

  const _SectionHeading({required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        Text(
          'Skills & Expertise',
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Technologies and tools I work with',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ── Skill categories grid ─────────────────────────────────────────────

class _SkillCategoriesGrid extends StatelessWidget {
  final ThemeData theme;

  const _SkillCategoriesGrid({required this.theme});

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
                child: _SkillCategoryCard(
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

// ── Skill category card ───────────────────────────────────────────────

class _SkillCategoryCard extends StatefulWidget {
  final SkillCategory category;
  final int index;
  final ThemeData theme;

  const _SkillCategoryCard({
    required this.category,
    required this.index,
    required this.theme,
  });

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final cat = widget.category;

    return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.scaffoldBackgroundColor,
              border: Border.all(
                color: _hovering
                    ? primary.withAlpha(60)
                    : onSurface.withAlpha(20),
              ),
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: primary.withAlpha(12),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Category header ──
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(cat.icon, color: primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.name, style: theme.textTheme.titleLarge),
                          const SizedBox(height: 2),
                          Text(
                            cat.description,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Skill bars ──
                for (int i = 0; i < cat.skills.length; i++) ...[
                  _SkillBar(
                    skill: cat.skills[i],
                    delayIndex: widget.index * 4 + i,
                    theme: theme,
                  ),
                  if (i < cat.skills.length - 1) const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (200 + widget.index * 150).ms, duration: 600.ms)
        .slideY(
          begin: 0.15,
          end: 0,
          delay: (200 + widget.index * 150).ms,
          duration: 600.ms,
        );
  }
}

// ── Individual skill bar ──────────────────────────────────────────────

class _SkillBar extends StatelessWidget {
  final Skill skill;
  final int delayIndex;
  final ThemeData theme;

  const _SkillBar({
    required this.skill,
    required this.delayIndex,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final percentage = (skill.proficiency * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label + percentage ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percentage%',
              style: theme.textTheme.labelLarge?.copyWith(
                color: primary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Progress bar ──
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                // Background track
                Container(
                  width: double.infinity,
                  color: onSurface.withAlpha(15),
                ),
                // Filled portion (animated)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * skill.proficiency,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          colors: [primary, primary.withAlpha(180)],
                        ),
                      ),
                    ).animate().scaleX(
                      begin: 0,
                      end: 1,
                      alignment: Alignment.centerLeft,
                      delay: (400 + delayIndex * 60).ms,
                      duration: 800.ms,
                      curve: Curves.easeOutCubic,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
