import 'package:go_router/go_router.dart';
import 'package:my_portfolio/main.dart';
import '../layout/responsive_layout.dart';
import '../features/home/home_screen.dart';
import '../features/about/about_screen.dart';
import '../features/experiences/experience_screen.dart';
import '../features/projects/projects_screen.dart';
import '../features/admin/admin_screen.dart';
import '../features/contact/contact_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveLayout(themeNotifier: themeNotifier, child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/experience',
          builder: (context, state) => const ExperienceScreen(),
        ),
        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectsScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreen(),
        ),
      ],
    ),
    GoRoute(path: '/admin', builder: (context, state) => const AdminScreen()),
  ],
);
