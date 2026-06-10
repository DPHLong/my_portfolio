import 'package:flutter/material.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/about/widgets/bio_text.dart';
import 'package:my_portfolio/features/about/widgets/profile_card.dart';

class BioWidget extends StatelessWidget {
  final ThemeData theme;
  const BioWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    // ── Bio row: text + profile image placeholder ─────────────────────────
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: BioText(theme: theme)),
          const SizedBox(width: 48),
          Expanded(flex: 2, child: ProfileCard(theme: theme)),
        ],
      );
    }

    return Column(
      children: [
        ProfileCard(theme: theme),
        const SizedBox(height: 32),
        BioText(theme: theme),
      ],
    );
  }
}
