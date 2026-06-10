import 'package:flutter/material.dart';
import 'package:my_portfolio/features/about/widgets/bio_widget.dart';
import 'package:my_portfolio/features/about/widgets/section_heading.dart';
import 'package:my_portfolio/features/skills/skills_section.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Section heading ──
              SectionHeading(theme: theme),
              const SizedBox(height: 48),
              // ── Bio + Photo (responsive) ──
              BioWidget(theme: theme),
              const SizedBox(height: 64),
              // ── Skills ──
              const SkillsSection(),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
