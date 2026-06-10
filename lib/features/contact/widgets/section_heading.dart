import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SectionHeading extends StatelessWidget {
  final ThemeData theme;
  const SectionHeading({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        Text(
          'Get In Touch',
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
          'Have a project in mind or want to connect? Let\'s talk!',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}
