import 'package:flutter/material.dart';
import 'package:my_portfolio/features/home/widgets/decorative_code_block.dart';
import 'package:my_portfolio/features/home/widgets/hero_content.dart';

class DesktopLayout extends StatelessWidget {
  final ThemeData theme;
  final Color primary;
  final List<String> roles;

  const DesktopLayout({
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
          child: HeroContent(theme: theme, primary: primary, roles: roles),
        ),

        const SizedBox(width: 48),

        Expanded(
          flex: 2,
          child: DecorativeCodeBlock(primary: primary, theme: theme),
        ),
      ],
    );
  }
}
