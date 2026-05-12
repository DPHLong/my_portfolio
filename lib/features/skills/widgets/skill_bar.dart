import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/models/skill.dart';

class SkillBar extends StatelessWidget {
  final Skill skill;
  final int delayIndex;
  final ThemeData theme;

  const SkillBar({
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
