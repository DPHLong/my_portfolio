import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layout/responsive_layout.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PlaceholderScreen(title: 'Home / Hero Section'),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const PlaceholderScreen(title: 'About Me & Skills'),
        ),
        GoRoute(
          path: '/experience',
          builder: (context, state) => const PlaceholderScreen(title: 'Experience Timeline'),
        ),
        GoRoute(
          path: '/projects',
          builder: (context, state) => const PlaceholderScreen(title: 'Projects Showcase'),
        ),
      ],
    ),
  ],
);

// Temporary placeholder screen
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
