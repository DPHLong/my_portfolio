import 'package:flutter/material.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/home/widgets/desktop_layout.dart';
import 'package:my_portfolio/features/home/widgets/mobile_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _roles = [
    'Fullstack Developer',
    'Mobile & Web Engineer',
    'AI Engineering Enthusiast',
    'IT Support',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? DesktopLayout(theme: theme, primary: primary, roles: _roles)
              : MobileLayout(theme: theme, primary: primary, roles: _roles),
        ),
      ),
    );
  }
}
