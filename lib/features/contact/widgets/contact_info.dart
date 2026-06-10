import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/contact/widgets/contact_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatelessWidget {
  final ThemeData theme;
  const ContactInfo({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: Responsive.isMobile(context)
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text('Let\'s connect', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              'I\'m currently open to new opportunities and always happy '
              'to discuss interesting projects, collaborations, or ideas.',
              style: theme.textTheme.bodyLarge,
              textAlign: Responsive.isMobile(context)
                  ? TextAlign.center
                  : TextAlign.start,
            ),
            const SizedBox(height: 32),

            // ── Contact items ──
            ContactItem(
              icon: FontAwesomeIcons.envelope,
              label: 'Email',
              value: AppConstants.email,
              url: 'mailto:${AppConstants.email}',
              theme: theme,
            ),
            const SizedBox(height: 16),
            ContactItem(
              icon: FontAwesomeIcons.locationDot,
              label: 'Location',
              value: AppConstants.location,
              theme: theme,
            ),
            const SizedBox(height: 32),

            // ── Social links ──
            Text(
              'Find me on',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SocialButton(
                  icon: FontAwesomeIcons.github,
                  label: 'GitHub',
                  url: AppConstants.githubUrl,
                  theme: theme,
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.linkedin,
                  label: 'LinkedIn',
                  url: AppConstants.linkedInUrl,
                  theme: theme,
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 600.ms);
  }
}
// ── Contact item row ──────────────────────────────────────────────────

// ── Social button ─────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final String url;
  final ThemeData theme;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.theme,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovering ? primary.withAlpha(15) : Colors.transparent,
            border: Border.all(
              color: _hovering
                  ? primary.withAlpha(60)
                  : onSurface.withAlpha(25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: 18,
                color: _hovering ? primary : onSurface.withAlpha(150),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: widget.theme.textTheme.titleMedium?.copyWith(
                  color: _hovering ? primary : onSurface,
                  fontWeight: _hovering ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
