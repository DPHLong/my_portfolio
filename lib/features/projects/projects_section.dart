import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionProjects,
      child: Center(
        child: Text(
          'Projects Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
