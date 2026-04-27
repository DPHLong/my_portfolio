import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/data/models/project.dart';
import 'package:my_portfolio/features/projects/project_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;

  const ProjectCard({super.key, required this.project, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final p = widget.project;

    return GestureDetector(
          onTap: () => showProjectDetail(context, p),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovering = true),
            onExit: (_) => setState(() => _hovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: _hovering
                  ? (Matrix4.identity()..setTranslationRaw(0.0, -6.0, 0.0))
                  : Matrix4.identity(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: _hovering
                      ? primary.withAlpha(80)
                      : onSurface.withAlpha(20),
                ),
                boxShadow: _hovering
                    ? [
                        BoxShadow(
                          color: primary.withAlpha(20),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image placeholder ──
                  _ImagePlaceholder(
                    project: p,
                    hovering: _hovering,
                    primary: primary,
                    theme: theme,
                  ),

                  // ── Content ──
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Featured badge + category ──
                        Row(
                          children: [
                            if (p.featured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: primary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Featured',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: onSurface.withAlpha(30),
                                ),
                              ),
                              child: Text(
                                p.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── Title ──
                        Text(
                          p.title,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // ── Description ──
                        Text(
                          p.description,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),

                        // ── Tech tags ──
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: p.technologies.map((tech) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tech,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontSize: 12,
                                  color: onSurface.withAlpha(180),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // ── Action links ──
                        Row(
                          children: [
                            if (p.githubUrl != null)
                              _ActionLink(
                                icon: FontAwesomeIcons.github,
                                label: 'Code',
                                url: p.githubUrl!,
                                theme: theme,
                              ),
                            if (p.githubUrl != null && p.liveUrl != null)
                              const SizedBox(width: 16),
                            if (p.liveUrl != null)
                              _ActionLink(
                                icon: Icons.open_in_new_rounded,
                                label: 'Live Demo',
                                url: p.liveUrl!,
                                theme: theme,
                              ),
                            const Spacer(),
                            Text(
                              'View Details',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (200 + widget.index * 120).ms, duration: 600.ms)
        .slideY(
          begin: 0.15,
          end: 0,
          delay: (200 + widget.index * 120).ms,
          duration: 600.ms,
        );
  }
}

// ── Image placeholder ─────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  final Project project;
  final bool hovering;
  final Color primary;
  final ThemeData theme;

  const _ImagePlaceholder({
    required this.project,
    required this.hovering,
    required this.primary,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withAlpha(hovering ? 40 : 20),
            primary.withAlpha(hovering ? 70 : 40),
          ],
        ),
      ),
      child: Center(
        child: AnimatedScale(
          scale: hovering ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _iconForCategory(project.category),
            size: 48,
            color: primary.withAlpha(hovering ? 200 : 120),
          ),
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Mobile':
        return Icons.phone_android_rounded;
      case 'Web':
        return Icons.language_rounded;
      case 'AI / ML':
        return Icons.psychology_rounded;
      case 'Backend':
        return Icons.dns_rounded;
      case 'Game':
        return Icons.gamepad_rounded;
      default:
        return Icons.folder_rounded;
    }
  }
}

// ── Action link ───────────────────────────────────────────────────────

class _ActionLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final ThemeData theme;

  const _ActionLink({
    required this.icon,
    required this.label,
    required this.url,
    required this.theme,
  });

  @override
  State<_ActionLink> createState() => _ActionLinkState();
}

class _ActionLinkState extends State<_ActionLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.theme.colorScheme.primary;
    final onSurface = widget.theme.colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: _hovering ? primary : onSurface.withAlpha(150),
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: widget.theme.textTheme.bodySmall?.copyWith(
                color: _hovering ? primary : onSurface.withAlpha(150),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
