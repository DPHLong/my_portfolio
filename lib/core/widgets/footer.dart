import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor.withAlpha(30)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Social icons ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(
                    icon: FontAwesomeIcons.github,
                    url: AppConstants.githubUrl,
                    tooltip: 'GitHub',
                  ),
                  const SizedBox(width: 24),
                  _SocialIcon(
                    icon: FontAwesomeIcons.linkedin,
                    url: AppConstants.linkedInUrl,
                    tooltip: 'LinkedIn',
                  ),
                  const SizedBox(width: 24),
                  _SocialIcon(
                    icon: FontAwesomeIcons.envelope,
                    url: 'mailto:${AppConstants.email}',
                    tooltip: 'Email',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // ── Copyright ──
              Text(
                '\u00a9 $year ${AppConstants.name}. Built with Flutter.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha(120),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: () => _launchUrl(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovering ? primary.withAlpha(25) : Colors.transparent,
            ),
            child: FaIcon(
              widget.icon,
              size: 20,
              color: _hovering ? primary : onSurface.withAlpha(150),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
