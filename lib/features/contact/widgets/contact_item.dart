import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;
  final String? url;
  final ThemeData theme;

  const ContactItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: url != null
          ? () async {
              final uri = Uri.parse(url!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          : null,
      child: MouseRegion(
        cursor: url != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: FaIcon(icon, color: primary, size: 18)),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withAlpha(120),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: url != null ? primary : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
