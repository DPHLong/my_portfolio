import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';
import 'package:my_portfolio/features/about/about_data.dart';

class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: AppConstants.sectionAbout,
      globalKey: sectionKey,
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          // ── Section heading ──
          _SectionHeading(theme: theme),
          const SizedBox(height: 48),

          // ── Bio + Photo (responsive) ──
          _BioRow(theme: theme),
          const SizedBox(height: 64),

          // ── Journey timeline ──
          _JourneyTimeline(theme: theme),
          const SizedBox(height: 64),

          // ── Tech stack ──
          _TechStackGrid(theme: theme),
        ],
      ),
    );
  }
}

// ── Section Heading ───────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final ThemeData theme;

  const _SectionHeading({required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        Text(
          'About Me',
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
          'Get to know me and my journey',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ── Bio row: text + profile image placeholder ─────────────────────────

class _BioRow extends StatelessWidget {
  final ThemeData theme;

  const _BioRow({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _BioText(theme: theme)),
          const SizedBox(width: 48),
          Expanded(flex: 2, child: _ProfileCard(theme: theme)),
        ],
      );
    }

    return Column(
      children: [
        _ProfileCard(theme: theme),
        const SizedBox(height: 32),
        _BioText(theme: theme),
      ],
    );
  }
}

class _BioText extends StatelessWidget {
  final ThemeData theme;

  const _BioText({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.aboutSummary,
          style: theme.textTheme.bodyLarge,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 24),

        // ── Quick facts ──
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _QuickFact(
              icon: Icons.location_on_rounded,
              label: AppConstants.location,
              theme: theme,
            ),
            _QuickFact(
              icon: Icons.work_rounded,
              label: 'Open to opportunities',
              theme: theme,
            ),
            _QuickFact(
              icon: Icons.school_rounded,
              label: 'Always learning',
              theme: theme,
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }
}

class _QuickFact extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _QuickFact({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile card ──────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final ThemeData theme;

  const _ProfileCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isMobile = Responsive.isMobile(context);

    return Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 280 : double.infinity,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: onSurface.withAlpha(20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary.withAlpha(8), primary.withAlpha(20)],
            ),
          ),
          child: Column(
            children: [
              // ── Avatar placeholder ──
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withAlpha(25),
                  border: Border.all(color: primary.withAlpha(60), width: 3),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(AppConstants.profileImage),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.name,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Software Developer',
                style: theme.textTheme.bodyMedium?.copyWith(color: primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: onSurface.withAlpha(120),
                  ),
                  const SizedBox(width: 4),
                  Text(AppConstants.location, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.15, end: 0, duration: 600.ms);
  }
}

// ── Journey timeline ──────────────────────────────────────────────────

class _JourneyTimeline extends StatelessWidget {
  final ThemeData theme;

  const _JourneyTimeline({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      children: [
        Text(
          'My Journey',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 32),
        if (isMobile)
          Column(
            children: [
              for (int i = 0; i < AboutData.journey.length; i++) ...[
                _JourneyCard(
                  milestone: AboutData.journey[i],
                  index: i,
                  theme: theme,
                ),
                if (i < AboutData.journey.length - 1)
                  _TimelineConnector(theme: theme),
              ],
            ],
          )
        else
          Row(
            children: [
              for (int i = 0; i < AboutData.journey.length; i++) ...[
                Expanded(
                  child: _JourneyCard(
                    milestone: AboutData.journey[i],
                    index: i,
                    theme: theme,
                  ),
                ),
                if (i < AboutData.journey.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: theme.colorScheme.primary.withAlpha(100),
                    ),
                  ),
              ],
            ],
          ),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  final ThemeData theme;

  const _TimelineConnector({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: theme.colorScheme.primary.withAlpha(60),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final JourneyMilestone milestone;
  final int index;
  final ThemeData theme;

  const _JourneyCard({
    required this.milestone,
    required this.index,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: onSurface.withAlpha(20)),
            color: theme.scaffoldBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(milestone.icon, color: primary, size: 22),
              ),
              const SizedBox(height: 16),
              Text(
                milestone.subtitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: primary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(milestone.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(milestone.description, style: theme.textTheme.bodyMedium),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: (300 + index * 150).ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms);
  }
}

// ── Tech stack grid ───────────────────────────────────────────────────

class _TechStackGrid extends StatelessWidget {
  final ThemeData theme;

  const _TechStackGrid({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tech Stack',
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            for (int i = 0; i < AboutData.techStack.length; i++)
              _TechBadge(tech: AboutData.techStack[i], index: i, theme: theme),
          ],
        ),
      ],
    );
  }
}

class _TechBadge extends StatefulWidget {
  final TechItem tech;
  final int index;
  final ThemeData theme;

  const _TechBadge({
    required this.tech,
    required this.index,
    required this.theme,
  });

  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final onSurface = widget.theme.colorScheme.onSurface;
    final techColor = widget.tech.color;

    return MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _hovering ? techColor.withAlpha(20) : Colors.transparent,
              border: Border.all(
                color: _hovering
                    ? techColor.withAlpha(100)
                    : onSurface.withAlpha(25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  widget.tech.icon,
                  size: 18,
                  color: _hovering ? techColor : onSurface.withAlpha(150),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.tech.name,
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    color: _hovering ? techColor : onSurface,
                    fontWeight: _hovering ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (400 + widget.index * 80).ms, duration: 500.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          delay: (400 + widget.index * 80).ms,
          duration: 500.ms,
        );
  }
}
