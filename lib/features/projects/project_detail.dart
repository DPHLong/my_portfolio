import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/data/models/project.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows project details as a bottom sheet on mobile, or a dialog on desktop.
void showProjectDetail(BuildContext context, Project project) {
  if (Responsive.isMobile(context)) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectDetailSheet(project: project),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => _ProjectDetailDialog(project: project),
    );
  }
}

// ── Mobile: Draggable bottom sheet ────────────────────────────────────

class _ProjectDetailSheet extends StatelessWidget {
  final Project project;

  const _ProjectDetailSheet({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Drag handle ──
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withAlpha(40),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Scrollable content ──
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: _DetailContent(project: project),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Desktop/Tablet: Centered dialog ───────────────────────────────────

class _ProjectDetailDialog extends StatelessWidget {
  final Project project;

  const _ProjectDetailDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 700),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.onSurface.withAlpha(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header bar with close button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: theme.textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── Scrollable content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _DetailContent(project: project),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared detail content ─────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final Project project;

  const _DetailContent({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Hero icon area ──
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary.withAlpha(25), primary.withAlpha(50)],
            ),
          ),
          child: Center(
            child: Icon(
              _iconForCategory(project.category),
              size: 56,
              color: primary.withAlpha(180),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Badges row ──
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (project.featured)
              _Badge(
                label: 'Featured',
                color: primary,
                filled: true,
                theme: theme,
              ),
            _Badge(
              label: project.category,
              color: onSurface,
              filled: false,
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Title (shown on mobile, hidden on desktop since it's in header) ──
        if (Responsive.isMobile(context)) ...[
          Text(project.title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
        ],

        // ── Full description ──
        Text(project.description, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 28),

        // ── Technologies ──
        Text(
          'Technologies',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.technologies.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: primary.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primary.withAlpha(40)),
              ),
              child: Text(
                tech,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: primary,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),

        // ── Action buttons ──
        if (project.githubUrl != null || project.liveUrl != null) ...[
          Text(
            'Links',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (project.githubUrl != null)
                _DetailActionButton(
                  icon: FontAwesomeIcons.github,
                  label: 'View Source Code',
                  url: project.githubUrl!,
                  theme: theme,
                ),
              if (project.liveUrl != null)
                _DetailActionButton(
                  icon: Icons.open_in_new_rounded,
                  label: 'Live Demo',
                  url: project.liveUrl!,
                  theme: theme,
                  filled: true,
                ),
            ],
          ),
        ],
      ],
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
      default:
        return Icons.folder_rounded;
    }
  }
}

// ── Badge ─────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  final ThemeData theme;

  const _Badge({
    required this.label,
    required this.color,
    required this.filled,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withAlpha(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(filled ? 60 : 30)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: filled ? color : null,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ── Detail action button ──────────────────────────────────────────────

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final ThemeData theme;
  final bool filled;

  const _DetailActionButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.theme,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton.icon(
        onPressed: () => _launch(url),
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
    }
    return OutlinedButton.icon(
      onPressed: () => _launch(url),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
