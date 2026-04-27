import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';
import 'package:my_portfolio/features/projects/project_card.dart';
import 'package:my_portfolio/features/projects/project_data.dart';

class ProjectsSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const ProjectsSection({super.key, required this.sectionKey});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredProjects = _selectedCategory == 'All'
        ? ProjectData.projects
        : ProjectData.projects
              .where((p) => p.category == _selectedCategory)
              .toList();

    return SectionWrapper(
      sectionKey: AppConstants.sectionProjects,
      globalKey: widget.sectionKey,
      child: Column(
        children: [
          // ── Section heading ──
          _SectionHeading(theme: theme),
          const SizedBox(height: 32),

          // ── Category filter ──
          _CategoryFilter(
            selected: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
            theme: theme,
          ),
          const SizedBox(height: 40),

          // ── Project grid ──
          _ProjectGrid(
            projects: filteredProjects,
            key: ValueKey(_selectedCategory),
          ),
        ],
      ),
    );
  }
}

// ── Section heading ───────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final ThemeData theme;

  const _SectionHeading({required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        Text(
          'Projects',
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A selection of things I\'ve built',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ── Category filter chips ─────────────────────────────────────────────

class _CategoryFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;
  final ThemeData theme;

  const _CategoryFilter({
    required this.selected,
    required this.onSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: ProjectData.categories.map((cat) {
        final isActive = cat == selected;
        final primary = theme.colorScheme.primary;
        final onSurface = theme.colorScheme.onSurface;

        return GestureDetector(
          onTap: () => onSelected(cat),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? primary : onSurface.withAlpha(30),
                ),
              ),
              child: Text(
                cat,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isActive
                      ? (theme.brightness == Brightness.dark
                            ? theme.scaffoldBackgroundColor
                            : Colors.white)
                      : onSurface,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }
}

// ── Project grid (responsive) ─────────────────────────────────────────

class _ProjectGrid extends StatelessWidget {
  final List projects;

  const _ProjectGrid({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final screenType = Responsive.getScreenType(context);

    final crossAxisCount = switch (screenType) {
      ScreenType.desktop => 3,
      ScreenType.tablet => 2,
      ScreenType.mobile => 1,
    };

    if (projects.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text(
          'No projects in this category yet.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 24.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final cardWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < projects.length; i++)
              SizedBox(
                width: crossAxisCount == 1 ? constraints.maxWidth : cardWidth,
                child: ProjectCard(project: projects[i], index: i),
              ),
          ],
        );
      },
    );
  }
}
