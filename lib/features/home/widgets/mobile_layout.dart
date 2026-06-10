import 'package:flutter/material.dart';
import 'package:my_portfolio/features/home/widgets/decorative_code_block.dart';
import 'package:my_portfolio/features/home/widgets/hero_content.dart';

class MobileLayout extends StatelessWidget {
  final ThemeData theme;
  final Color primary;
  final List<String> roles;

  const MobileLayout({
    required this.theme,
    required this.primary,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeroContent(theme: theme, primary: primary, roles: roles),
        const SizedBox(height: 40),
        DecorativeCodeBlock(primary: primary, theme: theme),
      ],
    );
  }
}
