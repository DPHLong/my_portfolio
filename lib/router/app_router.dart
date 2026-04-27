import 'package:go_router/go_router.dart';
import '../layout/responsive_layout.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';
import '../screens/experience_screen.dart';
import '../screens/projects_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveLayout(child: child);
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
      ],
    ),
  ],
);
