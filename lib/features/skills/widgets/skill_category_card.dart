import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/features/skills/skills_data.dart';
import 'package:my_portfolio/features/skills/widgets/skill_bar.dart';

class SkillCategoryCard extends StatefulWidget {
  final SkillCategory category;
  final int index;
  final ThemeData theme;

  const SkillCategoryCard({
    required this.category,
    required this.index,
    required this.theme,
  });

  @override
  State<SkillCategoryCard> createState() => SkillCategoryCardState();
}

class SkillCategoryCardState extends State<SkillCategoryCard> {
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
                      child: Center(
                        child: FaIcon(cat.icon, color: primary, size: 22),
                      ),
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
                  SkillBar(
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
