import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/home/typing_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _roles = [
    'Fullstack Developer',
    'Mobile & Web Engineer',
    'AI Engineering Enthusiast',
    'IT Support',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: isDesktop
              ? _DesktopLayout(theme: theme, primary: primary, roles: _roles)
              : _MobileLayout(theme: theme, primary: primary, roles: _roles),
        ),
      ),
    );
  }
}

// ── Desktop: text left, decorative element right ──────────────────────

class _DesktopLayout extends StatelessWidget {
  final ThemeData theme;
  final Color primary;
  final List<String> roles;

  const _DesktopLayout({
    required this.theme,
    required this.primary,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _HeroContent(theme: theme, primary: primary, roles: roles),
        ),

        const SizedBox(width: 48),

        Expanded(
          flex: 2,
          child: _DecorativeCodeBlock(primary: primary, theme: theme),
        ),
      ],
    );
  }
}

// ── Mobile: stacked vertically ────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final ThemeData theme;
  final Color primary;
  final List<String> roles;

  const _MobileLayout({
    required this.theme,
    required this.primary,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _HeroContent(
          theme: theme,
          primary: primary,
          roles: roles,
          // onViewProjects: onViewProjects,
        ),
        const SizedBox(height: 40),
        _DecorativeCodeBlock(primary: primary, theme: theme),
      ],
    );
  }
}

class _homeWidget extends StatelessWidget {
  const _homeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HELLO, WORLD!',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).primaryColor,
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'I build cross platform apps and intelligent systems.',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32),
          Text(
            'Experienced Software Developer specializing in Flutter, Firebase, Java, and C#. Currently expanding my horizons into AI Engineering to build the next generation of smart applications.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/projects'),
                child: const Text('VIEW PROJECTS'),
              ),
              OutlinedButton(
                onPressed: () => context.go('/about'),
                child: const Text('ABOUT ME'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Hero text content ─────────────────────────────────────────────────

class _HeroContent extends StatelessWidget {
  final ThemeData theme;
  final Color primary;
  final List<String> roles;
  // final VoidCallback? onViewProjects;

  const _HeroContent({
    required this.theme,
    required this.primary,
    required this.roles,
    // this.onViewProjects,
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

// ── Decorative code block (visual flair) ──────────────────────────────

class _DecorativeCodeBlock extends StatelessWidget {
  final Color primary;
  final ThemeData theme;

  const _DecorativeCodeBlock({required this.primary, required this.theme});

  @override
  Widget build(BuildContext context) {
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: onSurface.withAlpha(20)),
            boxShadow: [
              BoxShadow(
                color: primary.withAlpha(15),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Window dots ──
              Row(
                children: [
                  _dot(const Color(0xFFFF5F57)),
                  const SizedBox(width: 8),
                  _dot(const Color(0xFFFFBD2E)),
                  const SizedBox(width: 8),
                  _dot(const Color(0xFF28C840)),
                  const Spacer(),
                  Text(
                    'developer.dart',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurface.withAlpha(80),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Pseudo-code ──
              _codeLine('class', ' Developer ', '{', primary, onSurface, theme),
              _propertyLine('  name', '"Pham Hoang Long Dang"', primary, theme),
              _propertyLine('  role', '"Software Engineer"', primary, theme),
              _propertyLine('  focus', '"AI Engineering"', primary, theme),
              _propertyLine(
                '  passion',
                '"Building Smart Apps"',
                primary,
                theme,
              ),
              const SizedBox(height: 8),
              _codeLine(
                '  ',
                'createAwesome()',
                ' => true;',
                primary,
                onSurface,
                theme,
              ),
              const SizedBox(height: 4),
              Text(
                '}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withAlpha(180),
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: 800.ms)
        .slideX(begin: 0.15, end: 0, duration: 800.ms);
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _codeLine(
    String keyword,
    String name,
    String rest,
    Color keywordColor,
    Color textColor,
    ThemeData theme,
  ) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
        children: [
          TextSpan(
            text: keyword,
            style: TextStyle(color: keywordColor),
          ),
          TextSpan(
            text: name,
            style: TextStyle(color: textColor.withAlpha(220)),
          ),
          TextSpan(
            text: rest,
            style: TextStyle(color: textColor.withAlpha(120)),
          ),
        ],
      ),
    );
  }

  Widget _propertyLine(
    String key,
    String value,
    Color keyColor,
    ThemeData theme,
  ) {
    final green = theme.brightness == Brightness.dark
        ? const Color(0xFF7EE787)
        : const Color(0xFF1A7F37);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
          children: [
            TextSpan(
              text: key,
              style: TextStyle(color: keyColor.withAlpha(180)),
            ),
            TextSpan(
              text: ': ',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(100),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: green),
            ),
            TextSpan(
              text: ';',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
