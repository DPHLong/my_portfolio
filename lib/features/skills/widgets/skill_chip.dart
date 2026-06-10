import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String skill;
  const SkillChip({super.key, required this.skill});

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
