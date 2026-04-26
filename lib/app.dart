import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/theme/app_theme.dart';
import 'package:my_portfolio/core/theme/theme_notifier.dart';
import 'package:my_portfolio/core/widgets/footer.dart';
import 'package:my_portfolio/core/widgets/nav_bar.dart';
import 'package:my_portfolio/core/widgets/scroll_service.dart';
import 'package:my_portfolio/features/about/about_section.dart';
import 'package:my_portfolio/features/contact/contact_section.dart';
import 'package:my_portfolio/features/home/home_section.dart';
import 'package:my_portfolio/features/projects/projects_section.dart';
import 'package:my_portfolio/features/skills/skills_section.dart';

// ── Theme Notifier (app-level) ────────────────────────────────────────
final ThemeNotifier themeNotifier = ThemeNotifier();

// ── Portfolio Page ────────────────────────────────────────────────────

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollService _scrollService = ScrollService();

  @override
  void dispose() {
    _scrollService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keys = _scrollService.sectionKeys;

    return Scaffold(
      body: Column(
        children: [
          // ── Sticky nav bar ──
          NavBar(
            themeNotifier: themeNotifier,
            onNavTap: _scrollService.scrollToSection,
          ),

          // ── Scrollable content ──
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollService.scrollController,
              child: Column(
                children: [
                  HomeSection(sectionKey: keys[AppConstants.sectionHome]!),
                  AboutSection(sectionKey: keys[AppConstants.sectionAbout]!),
                  ProjectsSection(
                    sectionKey: keys[AppConstants.sectionProjects]!,
                  ),
                  SkillsSection(sectionKey: keys[AppConstants.sectionSkills]!),
                  ContactSection(
                    sectionKey: keys[AppConstants.sectionContact]!,
                  ),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Router ────────────────────────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PortfolioPage()),
  ],
);

// ── App Root ──────────────────────────────────────────────────────────

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'My Portfolio',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.themeMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
