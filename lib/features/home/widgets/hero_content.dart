// ── Hero text content ─────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/home/widgets/typing_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroContent extends StatelessWidget {
  final ThemeData theme;
  final Color primary;
  final List<String> roles;

  const HeroContent({
    required this.theme,
    required this.primary,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Greeting badge ──
        Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary.withAlpha(60)),
              ),
              child: Text(
                'Hello, I\'m',
                style: theme.textTheme.labelLarge?.copyWith(color: primary),
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.3, end: 0, duration: 600.ms),

        const SizedBox(height: 20),

        // ── Name ──
        Text(
              AppConstants.name,
              style: isMobile
                  ? theme.textTheme.displaySmall
                  : theme.textTheme.displayLarge,
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.1, end: 0, duration: 600.ms),

        const SizedBox(height: 12),

        // ── Typing animation for roles ──
        TypingAnimation(
          texts: roles,
          style:
              (isMobile
                      ? theme.textTheme.headlineSmall
                      : theme.textTheme.headlineMedium)
                  ?.copyWith(color: primary),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

        const SizedBox(height: 24),

        // ── Brief intro ──
        Text(
          'Software developer specializing in Flutter & Firebase with a '
          'background in Java and C#. Currently diving into AI Engineering '
          'to build intelligent, cross-platform applications.',
          style: theme.textTheme.bodyLarge,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

        const SizedBox(height: 36),

        // ── CTA buttons ──
        Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/projects'),
                  icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                  label: const Text('View Projects'),
                ),
                OutlinedButton.icon(
                  onPressed: _launchResume,
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download Resume'),
                ),
              ],
            )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms),
      ],
    );
  }

  Future<void> _launchResume() async {
    if (AppConstants.resumeUrl.isEmpty) return;
    final uri = Uri.parse(AppConstants.resumeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
