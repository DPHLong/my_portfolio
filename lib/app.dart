import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/features/home/home_section.dart';
import 'package:my_portfolio/features/about/about_section.dart';
import 'package:my_portfolio/features/projects/projects_section.dart';
import 'package:my_portfolio/features/skills/skills_section.dart';
import 'package:my_portfolio/features/contact/contact_section.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: HomeSection()),
          SliverToBoxAdapter(child: AboutSection()),
          SliverToBoxAdapter(child: ProjectsSection()),
          SliverToBoxAdapter(child: SkillsSection()),
          SliverToBoxAdapter(child: ContactSection()),
        ],
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PortfolioPage()),
  ],
);

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
