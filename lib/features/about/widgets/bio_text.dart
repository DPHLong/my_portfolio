import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/about/widgets/quick_fact.dart';

class BioText extends StatelessWidget {
  final ThemeData theme;
  const BioText({super.key, required this.theme});

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
            QuickFact(
              icon: Icons.location_on_rounded,
              label: AppConstants.location,
              theme: theme,
            ),
            QuickFact(
              icon: Icons.work_rounded,
              label: 'Open to opportunities',
              theme: theme,
            ),
            QuickFact(
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
